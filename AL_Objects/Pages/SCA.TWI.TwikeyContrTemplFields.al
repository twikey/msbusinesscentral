page 71016584 "SCA.TWI.ContrTemplFields"
{
    PageType = List;
    SourceTable = "SCA.TWI.TwikeyContrTemplField";
    Caption = 'Twikey Contract Template Fields';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Id; Rec.Id)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Field Name"; Rec."Field Name")
                {
                    ApplicationArea = All;
                }
                field(Mandatory; Rec.Mandatory)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        myInt: Integer;
}