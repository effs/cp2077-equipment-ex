module EquipmentEx

struct EntityNameOffsetMapping {
    public let garmentOffset: Int32;
    public let entityName: CName;
}

struct AppearanceNameOffsetMapping {
    public let garmentOffset: Int32;
    public let appearanceTokens: array<String>;
}

struct OffsetMappingMatch {
    public let garmentOffset: Int32;
    public let score: Int32;
}

class OutfitOffsetMatcher {
    private let m_entityMappings: array<EntityNameOffsetMapping>;
    private let m_appearanceMappings: array<AppearanceNameOffsetMapping>;

    public func MapEntities(mappings: array<EntityNameOffsetMapping>) {
        this.m_entityMappings = mappings;
    }

    public func MapAppearances(mappings: array<AppearanceNameOffsetMapping>) {
        this.m_appearanceMappings = mappings;
    }
    
    public func Match(item: ref<Clothing_Record>) -> Int32 {
        let entityName = item.EntityName();
        let appearanceName = NameToString(item.AppearanceName());

        // Appearance exact match
        for mapping in this.m_appearanceMappings {
            for appearanceToken in mapping.appearanceTokens {
                if Equals(appearanceName, appearanceToken) {
                    return mapping.garmentOffset;
                }
            }
        }

        // Appearance partial match
        let match: OffsetMappingMatch;
        for mapping in this.m_appearanceMappings {
            for appearanceToken in mapping.appearanceTokens {
                if StrFindFirst(appearanceName, appearanceToken) >= 0 {
                    // return mapping.garmentOffset;
                    if StrLen(appearanceToken) > match.score {
                        match.score = StrLen(appearanceToken);
                        match.garmentOffset = mapping.garmentOffset;
                    }
                }
            }
        }
        if match.score > 0 {
            return match.garmentOffset;
        }

        // Entity exact match
        for mapping in this.m_entityMappings {
            if Equals(entityName, mapping.entityName) {
                return mapping.garmentOffset;
            }
        }

        return 0;
    }

    public static func Create() -> ref<OutfitOffsetMatcher> {
        return new OutfitOffsetMatcher();
    }
}
