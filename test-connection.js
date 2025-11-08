// Quick test to check if Supabase connection works
// Run this in your browser console (F12) while on your app

console.log('Testing Supabase connection...');

// Test fetching clinics
fetch('https://nfijoztlzlfltbghydpy.supabase.co/rest/v1/clinics?select=*', {
  headers: {
    'apikey': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5maWpvenRsemxmbHRiZ2h5ZHB5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI1ODA5NTYsImV4cCI6MjA3ODE1Njk1Nn0.8NNcNiH1eMFotgEgFXf1b5JVvNr8A5uoewXqVCuW2Oc',
    'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5maWpvenRsemxmbHRiZ2h5ZHB5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI1ODA5NTYsImV4cCI6MjA3ODE1Njk1Nn0.8NNcNiH1eMFotgEgFXf1b5JVvNr8A5uoewXqVCuW2Oc'
  }
})
.then(res => res.json())
.then(data => {
  console.log('✅ Clinics found:', data.length);
  console.log('Clinics:', data);
  if (data.length === 0) {
    console.log('⚠️ No clinics in database. You need to add dummy data!');
    console.log('📖 See FIX_EMPTY_DATA.md for instructions');
  }
})
.catch(err => {
  console.error('❌ Error fetching clinics:', err);
});

// Test fetching pharmacies
fetch('https://nfijoztlzlfltbghydpy.supabase.co/rest/v1/pharmacies?select=*', {
  headers: {
    'apikey': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5maWpvenRsemxmbHRiZ2h5ZHB5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI1ODA5NTYsImV4cCI6MjA3ODE1Njk1Nn0.8NNcNiH1eMFotgEgFXf1b5JVvNr8A5uoewXqVCuW2Oc',
    'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5maWpvenRsemxmbHRiZ2h5ZHB5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI1ODA5NTYsImV4cCI6MjA3ODE1Njk1Nn0.8NNcNiH1eMFotgEgFXf1b5JVvNr8A5uoewXqVCuW2Oc'
  }
})
.then(res => res.json())
.then(data => {
  console.log('✅ Pharmacies found:', data.length);
  console.log('Pharmacies:', data);
  if (data.length === 0) {
    console.log('⚠️ No pharmacies in database. You need to add dummy data!');
    console.log('📖 See FIX_EMPTY_DATA.md for instructions');
  }
})
.catch(err => {
  console.error('❌ Error fetching pharmacies:', err);
});
