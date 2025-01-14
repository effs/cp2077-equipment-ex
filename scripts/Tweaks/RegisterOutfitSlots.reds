module EquipmentEx

class RegisterOutfitSlots extends ScriptableTweak {
    protected func OnApply() -> Void {
        let outfitSlots = OutfitConfig.OutfitSlots();

        for outfitSlot in outfitSlots {
            TweakDBManager.CreateRecord(outfitSlot.slotID, n"AttachmentSlot_Record");
            TweakDBManager.SetFlat(outfitSlot.slotID + t".localizedName", outfitSlot.displayName);

            if TDBID.IsValid(outfitSlot.parentID) {
                TweakDBManager.SetFlat(outfitSlot.slotID + t".parentSlot", outfitSlot.parentID);
            }

            TweakDBManager.UpdateRecord(outfitSlot.slotID);
            TweakDBManager.RegisterName(outfitSlot.slotName);
        }

        let playerEntityTemplates = [
            r"base\\characters\\entities\\player\\player_wa_fpp.ent",
            r"base\\characters\\entities\\player\\player_wa_tpp.ent",
            r"base\\characters\\entities\\player\\player_wa_tpp_cutscene.ent",
            r"base\\characters\\entities\\player\\player_wa_tpp_cutscene_no_impostor.ent",
            r"base\\characters\\entities\\player\\player_wa_tpp_reflexion.ent",
            r"base\\characters\\entities\\player\\player_ma_fpp.ent",
            r"base\\characters\\entities\\player\\player_ma_tpp.ent",
            r"base\\characters\\entities\\player\\player_ma_tpp_cutscene.ent",
            r"base\\characters\\entities\\player\\player_ma_tpp_cutscene_no_impostor.ent",
            r"base\\characters\\entities\\player\\player_ma_tpp_reflexion.ent"
        ];

        for record in TweakDBInterface.GetRecords(n"Character_Record") {
            let character = record as Character_Record;
            if ArrayContains(playerEntityTemplates, character.EntityTemplatePath()) {
                let characterSlots = TweakDBInterface.GetForeignKeyArray(character.GetID() + t".attachmentSlots");

                for outfitSlot in outfitSlots {
                    if !ArrayContains(characterSlots, outfitSlot.slotID) {
                        ArrayPush(characterSlots, outfitSlot.slotID);
                    }
                }

                TweakDBManager.SetFlat(character.GetID() + t".attachmentSlots", characterSlots);
                TweakDBManager.UpdateRecord(character.GetID());
            }
        }
    }
}
