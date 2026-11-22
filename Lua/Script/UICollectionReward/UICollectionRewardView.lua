local CollectionReward = {
  self = nil,
  Img_BG = nil,
  Group_Stage = {
    self = nil,
    Img_Bg = nil,
    Txt_Num = {
      self = nil,
      Txt_Unlock = nil,
      Txt_Max = nil
    },
    Group_Num = nil,
    Img_Title = nil
  },
  Group_Progress = {
    self = nil,
    Img_Bg = nil,
    Group_Txt = {
      self = nil,
      Txt_0 = nil,
      Txt_1 = nil,
      Txt_CurrentNum = nil,
      Txt_2 = nil,
      Txt_AllNum = nil,
      Txt_3 = nil
    }
  },
  ScrollGrid_Stage = {
    self = nil,
    grid = {
      self = nil,
      Group_Bg = {
        self = nil,
        Group_UnClaimabe = {self = nil, Img_Bg = nil},
        Group_Claimable = {
          self = nil,
          Img_Bg_02 = nil,
          Img_Bg_01 = nil
        },
        Group_Claimed = {self = nil, Img_Bg_01 = nil}
      },
      Txt_Stage = nil,
      Txt_TargetNum = nil,
      Txt_QuestDes = nil,
      StaticGrid_Rewareds = {
        self = nil,
        grid = {
          self = nil,
          Group_CommonItem = {
            self = nil,
            Btn_Item = nil,
            Img_Bottom = nil,
            Img_Item = nil,
            Img_Mask = nil,
            Txt_Num = nil,
            Group_Effect = nil
          }
        }
      },
      Group_Deco = {
        self = nil,
        Group_UnClaimabe = {
          self = nil,
          Img_Line = nil,
          Img_Deco = nil
        },
        Group_Claimable = {
          self = nil,
          Img_Line = nil,
          Img_Deco = nil
        },
        Group_Claimed = {
          self = nil,
          Img_Line = nil,
          Img_Deco = nil,
          Img_Mask = nil,
          Txt_Claimed = nil
        }
      },
      Btn_Claim = nil
    }
  },
  Group_CommonTopLeft = {
    self = nil,
    Btn_Return = nil,
    Btn_Home = nil,
    Btn_Menu = nil,
    Btn_Help = {
      self = nil,
      Img_Tips = {
        self = nil,
        Img_icon = nil,
        Txt_ = nil
      }
    }
  }
}
return CollectionReward
