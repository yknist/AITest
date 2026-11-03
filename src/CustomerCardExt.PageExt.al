pageextension 50100 "AIT Customer Card Ext" extends "Customer Card"
{
    actions
    {
        addlast(processing)
        {
            action(AITTestAction)
            {
                ApplicationArea = All;
                Caption = 'Test Action';
                ToolTip = 'Shows a test message for the current customer.';
                Image = TestFile;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    TestMsg: Label 'Hello from AITest! Customer: %1 - %2', Comment = '%1 = No., %2 = Name';
                begin
                    Message(TestMsg, Rec."No.", Rec.Name);
                end;
            }
        }
    }
}
