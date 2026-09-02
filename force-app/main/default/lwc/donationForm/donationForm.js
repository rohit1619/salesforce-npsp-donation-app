import { LightningElement, track } from 'lwc';

export default class DonationForm extends LightningElement {
    @track donor = { firstName: '', lastName: '', email: '' };
    @track donationType = 'One-Time';
    @track frequency = '';
    @track amount = 25;
    @track isSubmitted = false;
    @track mockToken = '';

    donationTypeOptions = [
        { label: 'One-Time', value: 'One-Time' },
        { label: 'Recurring', value: 'Recurring' }
    ];

    frequencyOptions = [
        { label: 'Monthly', value: 'Monthly' },
        { label: 'Quarterly', value: 'Quarterly' },
        { label: 'Yearly', value: 'Yearly' }
    ];

    get isRecurring() {
        return this.donationType === 'Recurring';
    }

    handleInputChange(event) {
        const field = event.target.name;
        if (this.donor[field] !== undefined) {
            this.donor[field] = event.target.value;
        } else if (field === 'amount') {
            this.amount = event.target.value;
        } else if (field === 'frequency') {
            this.frequency = event.target.value;
        }
    }

    handleTypeChange(event) {
        this.donationType = event.target.value;
        if (this.donationType === 'One-Time') {
            this.frequency = '';
        }
    }

    handleSubmit() {
        // Validate native client-side inputs
        const allValid = [...this.template.querySelectorAll('lightning-input, lightning-combobox')]
            .reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
            }, true);

        if (allValid) {
            // Client-Side Tokenization Simulation (PCI Compliance safeguard)
            this.mockToken = 'tok_mock_' + Math.random().toString(36).substr(2, 9).toUpperCase();
            this.isSubmitted = true;
            
            // Note: You can plug in your secure Apex controller call here later!
            console.log('Donor Data Payload:', JSON.stringify(this.donor));
            console.log('Gift Amount:', this.amount);
            console.log('Type & Schedule:', this.donationType, this.frequency);
            console.log('Secure Process Token generated:', this.mockToken);
        }
    }
}