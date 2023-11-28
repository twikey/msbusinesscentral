page 71016579 "SCA.TWI.ContractTemplates"
{
    PageType = List;
    SourceTable = "SCA.TWI.TwikeyContractTemplate";
    Caption = 'Twikey Contract Templates';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Id; Rec.Id)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Send Mail on Invite"; Rec."Send Mail on Invite")
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
            action(Fields)
            {
                Caption = 'Additional Fields';
                RunObject = page "SCA.TWI.ContrTemplFields";
                RunPageLink = Id = field(Id);
                ApplicationArea = All;
                Image = SelectField;
                Promoted = true;
                PromotedCategory = Process;
            }
        }
    }


    var
        myInt: Integer;
}