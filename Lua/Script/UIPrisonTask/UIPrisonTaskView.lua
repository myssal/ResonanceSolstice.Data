local PrisonTask = {
  self = nil,
  Img_B = nil,
  Img_Bg = nil,
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
  Img_NPCMask = nil,
  Group_Main = {
    self = nil,
    ScrollGrid_ = {
      self = nil,
      grid = {
        self = nil,
        Group_Info = {
          self = nil,
          Group_incomplete = {
            self = nil,
            Img_Btm = nil,
            Img_Tab = {self = nil, Txt_ = nil},
            Group_Track = {
              self = nil,
              Btn_Track = nil,
              Txt_ = nil
            },
            Group_Cancel = {
              self = nil,
              Btn_Cancel = nil,
              Txt_ = nil
            }
          },
          Group_Complete = {
            self = nil,
            Img_Btm = nil,
            Img_Tab = {self = nil, Txt_ = nil},
            Group_Get = {
              self = nil,
              Btn_Get = nil,
              Txt_ = nil
            }
          },
          Img_RewardBG = {
            self = nil,
            Img_ = nil,
            Txt_ = nil
          },
          Txt_Name = nil,
          Group_Reward = {
            self = nil,
            ScrollGrid_Reward = {
              self = nil,
              grid = {
                self = nil,
                Group_Item = {
                  self = nil,
                  Btn_Item = nil,
                  Img_Bottom = nil,
                  Img_Item = nil,
                  Img_Mask = nil,
                  Group_Break = {
                    self = nil,
                    Img_Mask = {self = nil, Img_Face = nil},
                    Img_F = nil
                  },
                  Txt_Num = nil,
                  Img_Type01 = nil,
                  Img_Type02 = nil,
                  Group_EType = {
                    self = nil,
                    Img_IconBg = nil,
                    Img_Icon = nil
                  },
                  Img_TimeLeft = {
                    self = nil,
                    Img_ = nil,
                    Txt_ = nil
                  },
                  Group_Extra = {
                    self = nil,
                    Img_bg = {self = nil, Txt_txt = nil}
                  },
                  Group_Effect = nil
                }
              }
            }
          },
          Group_Got = {
            self = nil,
            Img_Got = nil,
            Txt_ = nil,
            Img_Mask = nil
          }
        }
      }
    }
  },
  Group_IslandLv = {
    self = nil,
    Btn_Reputation = {self = nil, Img_Click = nil},
    Txt_Num = nil,
    Img_PBBG = nil,
    Img_PB = nil,
    Group_Level = {
      self = nil,
      Txt_Grade = nil,
      Txt_LV = nil
    }
  }
}
return PrisonTask
