module MyModule::ClinicAppointments {

    use aptos_framework::signer;
    use aptos_framework::token;
    use aptos_framework::token::Token;
    use aptos_framework::token::TokenStore;

    /// Clinic creates an appointment ticket as an NFT
    public fun create_ticket(clinic: &signer, name: vector<u8>, description: vector<u8>, uri: vector<u8>) {
        let collection_name = b"ClinicAppointments";

        // Create collection if not exists
        token::create_collection(
            clinic,
            collection_name,
            b"Appointment Tickets Collection",
            uri,
            false,  // no max supply
            false,  // mutable
            false   // transferable
        );

        // Create the NFT ticket (appointment slot)
        token::create_token(
            clinic,
            collection_name,
            name,
            description,
            1, // supply = 1
            0, // no royalty
            uri,
            clinic.address(),
            1,
            0,
            false,
            false,
            false
        );
    }

    /// Patient books an appointment by claiming NFT ticket
    public fun book_appointment(patient: &signer, clinic: address, name: vector<u8>) {
        let collection_name = b"ClinicAppointments";

        token::offer_token(
            &clinic,
            signer::address_of(patient),
            collection_name,
            name,
            1
        );
        token::claim_token(patient, clinic, clinic, collection_name, name);
    }
}
