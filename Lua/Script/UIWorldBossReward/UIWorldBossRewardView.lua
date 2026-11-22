local WorldBossReward = {
  self = nil,
  Img_BG = nil,
  Group_Boss = {self = nil, Spine_Boss = nil},
  Img_Logo = nil,
  Group_BossList = {
    self = nil,
    Group_Boss = {
      self = nil,
      Btn_Boss = {
        self = nil,
        Group_On = {
          self = nil,
          Img_ = nil,
          Txt_Name = nil,
          Txt_Hp = nil
        },
        Group_Off = {
          self = nil,
          Img_ = nil,
          Txt_Name = nil,
          Txt_Hp = nil
        }
      }
    },
    StaticGrid_Boss = {
      self = nil,
      grid = {
        self = nil,
        Btn_Boss = {
          self = nil,
          Group_On = {
            self = nil,
            Img_ = nil,
            Txt_Name = nil,
            Txt_Hp = nil
          },
          Group_Off = {
            self = nil,
            Img_ = nil,
            Txt_Name = nil,
            Txt_Hp = nil
          }
        }
      }
    }
  },
  Group_RewardList = {
    self = nil,
    ScrollGrid_Level = {
      self = nil,
      grid = {
        self = nil,
        Group_Btn = {
          self = nil,
          Btn_On = {
            self = nil,
            Img_Bg = nil,
            Txt_T = nil,
            Txt_HpDes = nil,
            Txt_HpR = nil,
            Txt_Times = nil
          },
          Img_Off = {
            self = nil,
            Txt_T = nil,
            Txt_HpDes = nil,
            Txt_HpR = nil,
            Txt_Times = nil
          },
          Img_Got = {
            self = nil,
            Txt_HpDes = nil,
            Txt_HpR = nil,
            Txt_Times = nil
          }
        },
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
        },
        Txt_Name = nil,
        Txt_Times = nil,
        Img_Mask = {self = nil, Txt_T = nil}
      }
    }
  },
  Btn_Return = nil
}
return WorldBossReward
