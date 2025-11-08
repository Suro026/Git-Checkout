import { useEffect, useState } from "react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Calendar, Search, Activity, Clock, MapPin, FileText } from "lucide-react";
import { Link, useNavigate } from "react-router-dom";
import { supabase } from "@/integrations/supabase/client";
import { useAuth } from "@/hooks/useAuth";
import { signOut } from "@/lib/auth";
import { toast } from "sonner";
import { BookAppointment } from "@/components/BookAppointment";
import { OrderMedicine } from "@/components/OrderMedicine";
import { HealthMemory } from "@/components/HealthMemory";
import { MyMedicineOrders } from "@/components/MyMedicineOrders";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";

interface Appointment {
  id: string;
  appointment_date: string;
  appointment_time: string;
  status: string;
  notes: string;
  clinics: {
    clinic_name: string;
  };
  doctors: {
    name: string;
    specialties: {
      name: string;
    };
  } | null;
}

interface Pharmacy {
  id: string;
  pharmacy_name: string;
  address: string;
  phone: string;
}

interface Clinic {
  id: string;
  clinic_name: string;
  address: string;
  phone?: string;
  doctors: {
    specialties: {
      name: string;
    };
  }[];
}

const PatientDashboard = () => {
  const { user, loading: authLoading } = useAuth();
  const navigate = useNavigate();
  const [appointments, setAppointments] = useState<Appointment[]>([]);
  const [pharmacies, setPharmacies] = useState<Pharmacy[]>([]);
  const [clinics, setClinics] = useState<Clinic[]>([]);
  const [searchQuery, setSearchQuery] = useState("");
  const [specialtyFilter, setSpecialtyFilter] = useState("all");
  const [specialties, setSpecialties] = useState<{ id: string; name: string }[]>([]);
  const [patientName, setPatientName] = useState<string>("Patient");

  useEffect(() => {
    if (!authLoading && !user) {
      navigate('/login');
    }
  }, [user, authLoading, navigate]);

  useEffect(() => {
    if (user) {
      fetchAppointments();
      fetchPharmacies();
      fetchClinics();
      fetchSpecialties();
      fetchPatientName();
    }
  }, [user]);

  const fetchPatientName = async () => {
    if (!user?.id) return;
    
    const { data, error } = await supabase
      .from('profiles')
      .select('full_name')
      .eq('id', user.id)
      .single();

    if (!error && data?.full_name) {
      setPatientName(data.full_name);
    }
  };

  const fetchAppointments = async () => {
    const { data, error } = await supabase
      .from('appointments')
      .select(`
        id,
        appointment_date,
        appointment_time,
        status,
        notes,
        clinics (clinic_name),
        doctors (
          name,
          specialties (name)
        )
      `)
      .eq('patient_id', user?.id)
      .order('appointment_date', { ascending: true })
      .limit(5);

    if (!error && data) {
      setAppointments(data as any);
    }
  };

  const fetchPharmacies = async () => {
    const { data, error } = await supabase
      .from('pharmacies')
      .select('id, pharmacy_name, address, phone')
      .order('pharmacy_name')
      .limit(10);

    if (!error && data) {
      setPharmacies(data);
    } else if (error) {
      console.error('Error fetching pharmacies:', error);
    }
  };

  const fetchClinics = async () => {
    const { data, error } = await supabase
      .from('clinics')
      .select(`
        id,
        clinic_name,
        address,
        phone,
        doctors (
          specialties (name)
        )
      `)
      .order('clinic_name');

    if (!error && data) {
      setClinics(data as any);
    } else if (error) {
      console.error('Error fetching clinics:', error);
    }
  };

  const fetchSpecialties = async () => {
    const { data, error } = await supabase
      .from('specialties')
      .select('id, name')
      .order('name');

    if (!error && data) {
      setSpecialties(data);
    }
  };

  const handleLogout = async () => {
    const { error } = await signOut();
    if (error) {
      toast.error("Failed to logout");
    } else {
      toast.success("Logged out successfully");
      // Clear any local state
      setPatientName("Patient");
      // Navigate to home and force reload to clear auth state
      window.location.href = '/';
    }
  };

  const filteredClinics = clinics.filter(clinic => {
    const matchesSearch = clinic.clinic_name.toLowerCase().includes(searchQuery.toLowerCase()) ||
                         clinic.address.toLowerCase().includes(searchQuery.toLowerCase());
    
    if (specialtyFilter === "all") return matchesSearch;
    
    const hasSpecialty = clinic.doctors.some(
      d => (d.specialties as any)?.name === specialtyFilter
    );
    
    return matchesSearch && hasSpecialty;
  });

  return (
    <div className="min-h-screen bg-background">
      <header className="bg-card border-b">
        <div className="container mx-auto px-4 py-4 flex justify-between items-center">
          <div className="flex items-center gap-2">
            <Activity className="w-8 h-8 text-primary" />
            <h1 className="text-2xl font-bold">Kllinic</h1>
          </div>
          <div className="flex items-center gap-4">
            <span className="text-muted-foreground">Hello, {patientName}</span>
            <Button variant="outline" onClick={handleLogout}>
              Logout
            </Button>
          </div>
        </div>
      </header>

      <main className="container mx-auto px-4 py-8">
        <div className="mb-8">
          <h2 className="text-3xl font-bold mb-2">Patient Dashboard</h2>
          <p className="text-muted-foreground">Manage your healthcare appointments and records</p>
        </div>

        {/* Search Section */}
        <Card className="mb-8">
          <CardContent className="p-6">
            <div className="space-y-4">
              <div className="flex gap-4">
                <div className="relative flex-1">
                  <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-muted-foreground" />
                  <Input 
                    placeholder="Search for clinics by name or location..." 
                    className="pl-10"
                    value={searchQuery}
                    onChange={(e) => setSearchQuery(e.target.value)}
                  />
                </div>
              </div>
              <div className="flex gap-4">
                <Select value={specialtyFilter} onValueChange={setSpecialtyFilter}>
                  <SelectTrigger className="w-[200px]">
                    <SelectValue placeholder="Filter by specialty" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="all">All Specialties</SelectItem>
                    {specialties.map(spec => (
                      <SelectItem key={spec.id} value={spec.name}>
                        {spec.name}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Quick Actions */}
        <div className="grid md:grid-cols-4 gap-4 mb-8">
          <Card className="hover:shadow-lg transition-shadow">
            <CardContent className="p-6 text-center space-y-2">
              <Calendar className="w-10 h-10 mx-auto text-primary" />
              <h3 className="font-semibold">Book Appointment</h3>
              <BookAppointment onSuccess={fetchAppointments} />
            </CardContent>
          </Card>
          <Card className="hover:shadow-lg transition-shadow cursor-pointer">
            <CardContent className="p-6 text-center space-y-2">
              <Clock className="w-10 h-10 mx-auto text-accent" />
              <h3 className="font-semibold">My Appointments</h3>
              <p className="text-2xl font-bold text-primary">{appointments.length}</p>
            </CardContent>
          </Card>
          <Card className="hover:shadow-lg transition-shadow">
            <CardContent className="p-6 text-center space-y-2">
              <FileText className="w-10 h-10 mx-auto text-success" />
              <h3 className="font-semibold">Health Memory</h3>
              <HealthMemory />
            </CardContent>
          </Card>
          <Card className="hover:shadow-lg transition-shadow">
            <CardContent className="p-6 text-center space-y-2">
              <MapPin className="w-10 h-10 mx-auto text-warning" />
              <h3 className="font-semibold">Order Medicine</h3>
              <div className="flex gap-2 justify-center">
                <OrderMedicine />
                <MyMedicineOrders />
              </div>
            </CardContent>
          </Card>
        </div>

        <div className="grid md:grid-cols-2 gap-8 mb-8">
          {/* Upcoming Appointments */}
          <Card>
            <CardHeader>
              <CardTitle>Upcoming Appointments</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              {appointments.length === 0 ? (
                <p className="text-center text-muted-foreground py-8">No appointments yet</p>
              ) : (
                appointments.map((apt) => (
                  <div key={apt.id} className="flex items-start gap-4 p-4 border rounded-lg hover:bg-secondary/50 transition-colors">
                    <div className="w-12 h-12 rounded-full bg-primary/10 flex items-center justify-center flex-shrink-0">
                      <Calendar className="w-6 h-6 text-primary" />
                    </div>
                    <div className="flex-1">
                      <h4 className="font-semibold">{apt.clinics.clinic_name}</h4>
                      {apt.doctors && (
                        <p className="text-sm text-muted-foreground">
                          Dr. {apt.doctors.name} - {(apt.doctors.specialties as any)?.name}
                        </p>
                      )}
                      <div className="flex items-center gap-4 mt-2 text-sm">
                        <span className="flex items-center gap-1">
                          <Calendar className="w-4 h-4" />
                          {new Date(apt.appointment_date).toLocaleDateString()}
                        </span>
                        <span className="flex items-center gap-1">
                          <Clock className="w-4 h-4" />
                          {apt.appointment_time}
                        </span>
                      </div>
                      <span className={`inline-block mt-2 px-2 py-1 rounded text-xs ${
                        apt.status === 'confirmed' ? 'bg-success/20 text-success' :
                        apt.status === 'pending' ? 'bg-warning/20 text-warning' :
                        'bg-secondary text-secondary-foreground'
                      }`}>
                        {apt.status}
                      </span>
                    </div>
                  </div>
                ))
              )}
            </CardContent>
          </Card>

          {/* Available Clinics */}
          <Card>
            <CardHeader>
              <CardTitle>Available Clinics</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4 max-h-[400px] overflow-y-auto">
              {filteredClinics.length === 0 ? (
                <p className="text-center text-muted-foreground py-8">No clinics found</p>
              ) : (
                filteredClinics.slice(0, 5).map((clinic) => {
                  const uniqueSpecialties = [...new Set(
                    clinic.doctors.map(d => (d.specialties as any)?.name).filter(Boolean)
                  )];
                  
                  return (
                    <div key={clinic.id} className="p-4 border rounded-lg hover:bg-secondary/50 transition-colors">
                      <h4 className="font-semibold">{clinic.clinic_name}</h4>
                      <p className="text-sm text-muted-foreground">{clinic.address}</p>
                      {uniqueSpecialties.length > 0 && (
                        <div className="flex flex-wrap gap-1 mt-2">
                          {uniqueSpecialties.slice(0, 3).map((spec, idx) => (
                            <span key={idx} className="text-xs bg-primary/10 text-primary px-2 py-1 rounded">
                              {spec}
                            </span>
                          ))}
                        </div>
                      )}
                    </div>
                  );
                })
              )}
            </CardContent>
          </Card>
        </div>

        {/* Nearby Pharmacies */}
        <Card>
          <CardHeader>
            <CardTitle>Nearby Pharmacies</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="grid md:grid-cols-3 gap-4">
              {pharmacies.length === 0 ? (
                <p className="text-center text-muted-foreground py-8 col-span-3">No pharmacies found</p>
              ) : (
                pharmacies.map((pharmacy) => (
                  <div key={pharmacy.id} className="p-4 border rounded-lg hover:bg-secondary/50 transition-colors">
                    <div className="flex items-start gap-3">
                      <MapPin className="w-5 h-5 text-primary flex-shrink-0 mt-1" />
                      <div>
                        <h4 className="font-semibold">{pharmacy.pharmacy_name}</h4>
                        <p className="text-sm text-muted-foreground mt-1">{pharmacy.address}</p>
                        <p className="text-sm text-primary mt-2">{pharmacy.phone}</p>
                      </div>
                    </div>
                  </div>
                ))
              )}
            </div>
          </CardContent>
        </Card>
      </main>
    </div>
  );
};

export default PatientDashboard;
