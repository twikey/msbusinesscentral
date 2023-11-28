page 71016585 "SCA.TWI.TwikeyDocumentFields"
{
    PageType = List;
    SourceTable = "SCA.TWI.TwikeyDocumentField";
    Caption = 'Twikey Document Fields';

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
                    Visible = false;
                }
                field("Contract Template"; Rec."Contract Template")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                }
                field("Field Name"; Rec."Field Name")
                {
                    ApplicationArea = All;
                }
                field("Field Value"; Rec."Field Value")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    var
        myInt: Integer;
}