local BuildingList = {
  self = nil,
  Img_B = nil,
  Img_BG = nil,
  Img_BGMask = nil,
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
  },
  Group_NPC = {
    self = nil,
    Img_Role = nil,
    SpineAnimation_Character = nil,
    SpineAnimation_Alpha = nil,
    Img_Dialog = {self = nil, Txt_Talk = nil},
    Img_Name = {self = nil, Txt_Name = nil}
  },
  Img_NPCMask = nil,
  Group_Main = {
    self = nil,
    ScrollGrid_ = {
      self = nil,
      grid = {
        self = nil,
        Btn_List = {
          self = nil,
          Txt_ = nil,
          Img_ = nil,
          Group_Time = {
            self = nil,
            Img_1 = nil,
            Txt_Time = nil
          },
          Img_Limit = {
            self = nil,
            Txt_Dec = nil,
            Img_Icon = nil,
            Img_1 = nil,
            Group_Limit = {
              self = nil,
              Img_2 = nil,
              Txt_Limit = nil
            }
          }
        }
      }
    },
    Group_NpcInfo = {
      self = nil,
      Img_Icon = nil,
      Txt_Title = nil,
      Group_Station = {
        self = nil,
        Img_Icon = nil,
        Txt_Station = nil
      },
      Img_Line = nil
    }
  },
  Group_NpcInfo = {
    self = nil,
    Txt_Title = nil,
    Img_Icon = nil,
    Group_Station = {
      self = nil,
      Img_Icon = nil,
      Txt_Station = nil
    },
    Img_Line = nil
  },
  Group_Reputation = {
    self = nil,
    Btn_Reputation = {self = nil, Img_Click = nil},
    Txt_Grade = nil,
    Txt_Num = nil,
    Img_PBBG = nil,
    Img_PB = nil,
    Img_RedPoint = nil
  }
}
return BuildingList
