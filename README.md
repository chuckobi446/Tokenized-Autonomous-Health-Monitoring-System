# Tokenized Autonomous Health Monitoring System

A comprehensive blockchain-based health monitoring platform built on Stacks using Clarity smart contracts.

## Overview

This system provides autonomous health monitoring through five interconnected smart contracts that track vital signs, ensure medication compliance, coordinate appointments, detect emergencies, and provide wellness coaching.

## Architecture

### Core Contracts

1. **Vital Signs Tracking Contract** (`vital-signs.clar`)
    - Monitors blood pressure, heart rate, and other health metrics
    - Stores historical data with timestamps
    - Validates metric ranges and triggers alerts

2. **Medication Compliance Contract** (`medication-compliance.clar`)
    - Ensures proper prescription adherence and timing
    - Tracks medication schedules and dosages
    - Monitors compliance rates and missed doses

3. **Appointment Coordination Contract** (`appointment-coordination.clar`)
    - Manages healthcare provider scheduling and reminders
    - Handles appointment booking and cancellations
    - Tracks appointment history and outcomes

4. **Emergency Detection Contract** (`emergency-detection.clar`)
    - Identifies health crises through vital sign analysis
    - Triggers rapid response protocols
    - Maintains emergency contact information

5. **Wellness Coaching Contract** (`wellness-coaching.clar`)
    - Provides personalized health improvement guidance
    - Tracks wellness goals and achievements
    - Generates coaching recommendations

## Features

- **Decentralized Health Records**: Secure, immutable health data storage
- **Real-time Monitoring**: Continuous vital sign tracking and analysis
- **Automated Alerts**: Smart contract-based emergency detection
- **Compliance Tracking**: Medication adherence monitoring
- **Appointment Management**: Streamlined healthcare scheduling
- **Wellness Guidance**: Personalized health coaching

## Data Types

### Health Metrics
- Blood pressure (systolic/diastolic)
- Heart rate (BPM)
- Temperature (Celsius)
- Weight (kg)
- Blood glucose levels

### User Roles
- Patients: Primary users monitoring their health
- Healthcare Providers: Medical professionals accessing patient data
- Emergency Contacts: Individuals notified during health crises

## Security Features

- Principal-based access control
- Data validation and sanitization
- Emergency override mechanisms
- Audit trail for all health data modifications

## Getting Started

### Prerequisites
- Clarinet CLI installed
- Node.js and npm for testing
- Stacks wallet for deployment

### Installation

\`\`\`bash
git clone <repository-url>
cd health-monitoring-system
npm install
\`\`\`

### Testing

\`\`\`bash
npm test
\`\`\`

### Deployment

\`\`\`bash
clarinet deploy
\`\`\`

## Usage Examples

### Recording Vital Signs
\`\`\`clarity
(contract-call? .vital-signs record-vital-signs u120 u80 u72 u98.6 u70.5 u100)
\`\`\`

### Scheduling Medication
\`\`\`clarity
(contract-call? .medication-compliance add-medication "Aspirin" u100 u1 u1440)
\`\`\`

### Booking Appointment
\`\`\`clarity
(contract-call? .appointment-coordination book-appointment 'SP1PROVIDER u1640995200 "Regular Checkup")
\`\`\`

## Error Codes

- `ERR-NOT-AUTHORIZED` (u100): Unauthorized access attempt
- `ERR-INVALID-INPUT` (u101): Invalid input parameters
- `ERR-NOT-FOUND` (u102): Requested data not found
- `ERR-ALREADY-EXISTS` (u103): Duplicate entry attempt
- `ERR-EMERGENCY-ACTIVE` (u104): Emergency state active

## Contributing

1. Fork the repository
2. Create a feature branch
3. Write tests for new functionality
4. Ensure all tests pass
5. Submit a pull request

## License

MIT License - see LICENSE file for details
