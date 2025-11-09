# Health Community Feature

## Overview
The Health Community feature transforms Kllinic from a simple healthcare booking platform into a connected community where patients can support each other, share experiences, and stay informed about health events.

## Features Implemented

### 1. Community Posts & Discussions
- **Create Posts**: Patients can share questions, stories, discussions, and challenges
- **Anonymous Posting**: Option to post anonymously for sensitive topics
- **Post Types**: 
  - General Discussion
  - Ask a Question
  - Share Your Story
  - Health Challenge
- **Engagement**: Like and reply to posts
- **Real-time Updates**: Posts update automatically

### 2. Community Groups
- **Join Groups**: Find and join relevant health support groups
- **Group Categories**:
  - Condition Support (Diabetes, Heart Health, etc.)
  - Wellness Challenges (Walking groups, fitness)
  - Local Groups (Location-based communities)
  - Family Circles (New moms, elderly care)
- **Group Management**: Automatic member counting and role management

### 3. Health Events
- **Event Discovery**: Find health camps, vaccination drives, workshops, and screenings
- **Event Registration**: One-click registration for events
- **Event Types**:
  - Health Camps
  - Vaccination Drives
  - Health Workshops
  - Health Screenings
- **Event Details**: Date, time, location, cost, participant limits
- **Clinic Integration**: Clinics can create and manage their own events

### 4. User Engagement
- **Reputation System**: Track helpful contributions and community participation
- **Badges**: Earn badges for active participation
- **Like System**: Appreciate helpful posts and replies

## Database Schema

### Core Tables
- `community_groups`: Store community groups with categories and privacy settings
- `group_members`: Track group memberships and roles
- `community_posts`: Store all community posts with type and anonymity options
- `post_replies`: Store replies to posts
- `post_likes`: Track likes on posts and replies
- `health_events`: Store health events with registration capabilities
- `event_participants`: Track event registrations
- `user_reputation`: Track user engagement and reputation

### Security
- **Row Level Security (RLS)**: Implemented on all tables
- **Privacy Controls**: Anonymous posting options
- **Access Control**: Users can only access appropriate content

## Components Structure

```
src/components/
├── HealthCommunity.tsx              # Main community component
└── community/
    ├── CreatePostDialog.tsx         # Create new posts
    ├── JoinGroupDialog.tsx          # Find and join groups
    └── CreateEventDialog.tsx        # Create health events
```

## Integration

### Patient Dashboard
- Added as a new section in the Patient Dashboard
- Accessible via the Community quick action card
- Integrated with existing user authentication

### Clinic Dashboard
- Clinics can create health events
- Events are automatically linked to the clinic

## Sample Data
The system includes sample data for:
- 6 community groups across different categories
- 5 sample posts with different types
- 4 upcoming health events
- User reputation data

## Key Benefits

1. **Community Support**: Patients no longer feel alone in their health journey
2. **Knowledge Sharing**: Real experiences and practical tips from peers
3. **Event Discovery**: Easy access to local health events and camps
4. **Motivation**: Group challenges and peer support for healthy habits
5. **Accessibility**: Free and low-cost health events for the community

## Future Enhancements

1. **Private Messaging**: Direct communication between community members
2. **Health Challenges**: Structured wellness challenges with tracking
3. **Expert Q&A**: Verified doctors answering community questions
4. **Location-based Groups**: Automatic group suggestions based on location
5. **Push Notifications**: Real-time notifications for community activities

## Usage

1. **For Patients**: 
   - Access via Patient Dashboard → Community section
   - Create posts, join groups, register for events
   - Engage with community through likes and replies

2. **For Clinics**:
   - Create health events to reach more patients
   - Build community presence and trust

3. **For Community Building**:
   - Automatic group suggestions based on health conditions
   - Event recommendations based on location and interests

This feature positions Kllinic as the first healthcare platform to truly connect patients in a meaningful community, going beyond transactional relationships to create lasting support networks.