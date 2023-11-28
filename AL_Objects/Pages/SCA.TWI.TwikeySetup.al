page 71016577 "SCA.TWI.TwikeySetup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "SCA.TWI.TwikeySetup";
    Caption = 'Twikey Setup';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("Enable Twikey Integration"; Rec."Enable Twikey Integration")
                {
                    ApplicationArea = All;
                }
                field("Environment URL"; Rec."Environment URL")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field("API Key"; Rec."API Key")
                {
                    ApplicationArea = All;
                    ExtendedDatatype = Masked;
                }
                field("Enable Log"; Rec."Enable Log")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(ContractTemplates)
            {
                Caption = 'Contract Templates';
                Image = ContractPayment;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = page "SCA.TWI.ContractTemplates";
            }
            action(LogEntries)
            {
                Caption = 'Log Entries';
                Image = Log;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = page "SCA.TWI.TwikeyLogEntries";
            }
        }
        area(Processing)
        {
            action(UpdateStatus)
            {
                Caption = 'Update Status';
                Image = Interaction;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    TwikeyJobQueue: Codeunit "SCA.TWI.TwikeyJobQueue";
                begin
                    TwikeyJobQueue.Run();
                end;
            }

            group(ChangeEnvironment)
            {
                Caption = 'Change Environment';
                action(SetBetaEnvironment)
                {
                    Caption = 'Beta Environment';
                    Image = TestDatabase;
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var

                    begin
                        Rec."Environment URL" := 'https://api.beta.twikey.com/';
                    end;
                }

                action(SetProductionEnvironment)
                {
                    Caption = 'Production Environment';
                    Image = Database;
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var

                    begin
                        Rec."Environment URL" := 'https://api.twikey.com/';
                    end;
                }
            }
        }
    }


    trigger OnOpenPage()
    var
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;
    end;


    var
        myInt: Integer;
}