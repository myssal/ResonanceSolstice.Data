local PrisonShop = {
  self = nil,
  Img_B = nil,
  Img_BG = nil,
  Img_Mask = nil,
  Img_Blur = nil,
  Group_NPC = {
    self = nil,
    Img_Role = nil,
    SpineAnimation_Character = nil,
    SpineAnimation_Alpha = nil,
    Img_Dialog = {self = nil, Txt_Talk = nil},
    Img_Name = {self = nil, Txt_Name = nil}
  },
  Img_NPCMask = nil,
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
  Group_Resources = {
    self = nil,
    Group_GoldCoin = {
      self = nil,
      Img_BG = nil,
      Btn_GoldCoin = nil,
      Img_Icon = nil,
      Txt_Num = nil,
      Btn_Add = nil
    },
    Group_PrisonDian = {
      self = nil,
      Img_BG = nil,
      Btn_GoldCoin = nil,
      Img_Icon = nil,
      Txt_Num = nil,
      Btn_Add = nil
    }
  },
  Group_PrisonInfo = {
    self = nil,
    Txt_Warehouse = nil,
    Img_MainIcon = nil,
    Img_line = nil,
    Txt_Location = nil,
    Group_level = {
      self = nil,
      Img_Icon = nil,
      Txt_Prison = nil,
      Txt_PrisonLV = nil,
      Txt_PrisonEXP = nil,
      Group_PrisonEXP = {
        self = nil,
        Img_EXPBG = nil,
        Img_EXPBar = nil
      }
    }
  },
  HomeCOCShop = {
    self = nil,
    Group_Store = {
      self = nil,
      Img_BG = {self = nil, Img_ = nil},
      Group_Exchange = {
        self = nil,
        Group_Middle = {
          self = nil,
          ScrollGrid_List = {
            self = nil,
            grid = {
              self = nil,
              Img_Di = nil,
              Img_Icon = {self = nil, Btn_ = nil},
              Group_Name = {
                self = nil,
                Img_ = nil,
                Txt_Name = nil,
                Txt_Name_EN = {self = nil, Text = nil}
              },
              Group_NoNum = {
                self = nil,
                Img_Bg = nil,
                Img_ = nil,
                Txt_Num = nil
              },
              Group_Num = {
                self = nil,
                Img_Bg = nil,
                Img_ = nil,
                Txt_Num = nil
              },
              ScrollGrid_List = {
                self = nil,
                grid = {
                  self = nil,
                  Img_Empty = nil,
                  Group_Cost = {
                    self = nil,
                    Txt_Have = nil,
                    Txt_And = nil,
                    Txt_Need = nil
                  },
                  Group_Item = {
                    self = nil,
                    Btn_Item = nil,
                    Img_Bottom = nil,
                    Img_Item = nil,
                    Img_Mask = nil,
                    Group_Effect = nil
                  }
                }
              },
              Group_Time = {
                self = nil,
                Img_ = nil,
                Txt_Time = nil
              },
              Group_Btn = {
                self = nil,
                Group_Can = {
                  self = nil,
                  Img_ = nil,
                  Btn_ = nil
                },
                Group_Not = {
                  self = nil,
                  Img_ = nil,
                  Btn_ = nil
                }
              },
              Group_Extra = {
                self = nil,
                Txt_Num = nil,
                Img_Icon = {self = nil, Btn_ = nil}
              },
              Group_Allready = {
                self = nil,
                Img_ = nil,
                Group_ = {
                  self = nil,
                  Img_Bg = nil,
                  Img_ = nil,
                  Txt_ = nil
                }
              },
              Group_RestrictLV = {
                self = nil,
                Img_Mask = nil,
                Img_ = nil,
                Txt_LEVEL = nil,
                Txt_LV = nil,
                Txt_Prison = nil
              },
              Group_Target = {
                self = nil,
                Img_BG2 = nil,
                Img_Item2 = nil
              },
              Img_RedDot = nil
            }
          }
        }
      },
      Group_StoreTab = {
        self = nil,
        Img_BG = {self = nil, Img_ = nil},
        Group_Exchange = {
          self = nil,
          Btn_Purchase = {self = nil, Txt_Purchase = nil},
          Img_Exchange = {self = nil, Txt_Exchange = nil}
        },
        Group_Purchase = {
          self = nil,
          Btn_Exchange = {self = nil, Txt_Exchange = nil},
          Img_Purchase = {self = nil, Txt_Purchase = nil}
        }
      },
      Img_LittleTittle = nil,
      Txt_Title = nil,
      Img_Fornitureicon = nil
    }
  }
}
return PrisonShop
