page 71016580 "SCA.TWI.TwikeyDocuments"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "SCA.TWI.TwikeyDocument";
    Caption = 'Twikey Documents';
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contract Id"; Rec."Document Id")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Cancel Reason"; Rec."Cancel Reason")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Cancel)
            {
                Caption = 'Cancel';
                Image = Cancel;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = all;

                trigger OnAction()
                var
                    TwikeyMgt: Codeunit "SCA.TWI.TwikeyMgt";
                begin
                    TwikeyMgt.CancelContract(Rec);
                end;
            }
            action(Suspend)
            {
                Caption = 'Suspend';
                Image = DisableBreakpoint;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = all;

                trigger OnAction()
                var
                    TwikeyMgt: Codeunit "SCA.TWI.TwikeyMgt";
                begin
                    TwikeyMgt.SuspendDocument(Rec);
                end;
            }
            action(Reactivate)
            {
                Caption = 'Reactivate';
                Image = EnableBreakpoint;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = all;

                trigger OnAction()
                var
                    TwikeyMgt: Codeunit "SCA.TWI.TwikeyMgt";
                begin
                    TwikeyMgt.ReactivateDocument(Rec);
                end;
            }

        }
    }


    var
        myInt: Integer;
}