table 71016576 "SCA.TWI.TwikeySetup"
{
    DataClassification = CustomerContent;
    Caption = 'Twikey Setup';

    fields
    {
        field(1; "Primary Key"; Code[20])
        {
            DataClassification = CustomerContent;

        }
        field(2; "Environment URL"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Environment URL';
        }
        field(3; "API Key"; Text[150])
        {
            DataClassification = CustomerContent;
            Caption = 'API Key';
        }
        field(100; "Enable Log"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Enable Log';
        }
        field(101; "Enable Twikey Integration"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Enable Twikey Integration';
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }


}