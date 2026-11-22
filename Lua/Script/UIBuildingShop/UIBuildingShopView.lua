local BuildingShop = {
  self = nil,
  Img_B = nil,
  Img_BG = nil,
  Group_NPC = {
    self = nil,
    Img_Role = nil,
    SpineAnimation_Character = nil,
    SpineAnimation_Alpha = nil,
    Img_Dialog = {self = nil, Txt_Talk = nil},
    Img_Name = {self = nil, Txt_Name = nil}
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
  Group_Store = {
    self = nil,
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
      Group_GoldCoin1 = {
        self = nil,
        Img_BG = nil,
        Btn_GoldCoin = nil,
        Img_Icon = nil,
        Txt_Num = nil,
        Btn_Add = nil
      }
    },
    Img_BG = {self = nil, Img_ = nil},
    Group_Furniture = {
      self = nil,
      ScrollGrid_List = {
        self = nil,
        grid = {
          self = nil,
          Img_BG = {self = nil, Img_ = nil},
          Img_ = nil,
          Btn_1 = nil,
          Img_Mask = {self = nil, Img_Item = nil},
          Img_Mask1 = nil,
          Txt_Name = nil,
          Img_Quality = nil,
          Img_Time = {self = nil, Txt_Time = nil},
          Group_SY = {
            self = nil,
            Img_1 = nil,
            Txt_Num = nil
          },
          Group_Money = {
            self = nil,
            Img_Money = nil,
            Txt_MoneyNum = nil,
            Txt_ = nil
          },
          Group_Money2 = {
            self = nil,
            Img_Money = nil,
            Txt_MoneyNum = nil,
            Txt_ = nil
          },
          Group_Attribute = {
            self = nil,
            Group_AttributePlant = {
              self = nil,
              Img_AttributeIcon = nil,
              Txt_Scores = nil
            },
            Group_AttributeFish = {
              self = nil,
              Img_AttributeIcon = nil,
              Txt_Scores = nil
            },
            Group_AttributePet = {
              self = nil,
              Img_AttributeIcon = nil,
              Txt_Scores = nil
            },
            Group_AttributeAppetite = {
              self = nil,
              Img_AttributeIcon = nil,
              Txt_Scores = nil
            },
            Group_AttributeComfort = {
              self = nil,
              Img_AttributeIcon = nil,
              Txt_Scores = nil
            }
          },
          Txt_Num = nil,
          Img_ShouWan = {
            self = nil,
            Img_ = {
              self = nil,
              Txt_ = nil,
              Txt_EN = nil
            }
          },
          Img_AllLimit = {
            self = nil,
            Img_ = nil,
            Group_1 = {
              self = nil,
              Txt_Rep = nil,
              Txt_Grade = nil,
              Txt_Furniture = nil
            }
          }
        }
      },
      Group_Nothing = {
        self = nil,
        Img_Icon = nil,
        Txt_ = nil
      }
    },
    Group_StoreTab = {
      self = nil,
      Img_BG = {
        self = nil,
        StaticGrid_ = {
          self = nil,
          grid = {
            self = nil,
            Btn_Furniture = {
              self = nil,
              Group_Off = {
                self = nil,
                Img_Icon = nil,
                Txt_Name = nil
              },
              Group_On = {
                self = nil,
                Img_BG = nil,
                Group_ = {
                  self = nil,
                  Img_Icon = nil,
                  Txt_Name = nil
                }
              }
            }
          }
        }
      }
    },
    Group_Time = {
      self = nil,
      Img_TimeBG = nil,
      Txt_Time = nil,
      Img_1 = {self = nil, Btn_ = nil}
    },
    Img_LittleTittle = nil,
    Txt_Title = nil,
    Img_Fornitureicon = nil
  },
  Group_Tab = {
    self = nil,
    Img_Btm = nil,
    Img_Selected = nil,
    Btn_Buy = {
      self = nil,
      Group_Off = {
        self = nil,
        Img_ = nil,
        Txt_ = nil
      },
      Group_On = {
        self = nil,
        Img_ = nil,
        Txt_ = nil
      }
    },
    Btn_Sell = {
      self = nil,
      Group_Off = {
        self = nil,
        Img_ = nil,
        Txt_ = nil
      },
      Group_On = {
        self = nil,
        Img_ = nil,
        Txt_ = nil
      }
    }
  },
  Group_Item = {
    self = nil,
    Btn_Furniture = {
      self = nil,
      Group_Off = {
        self = nil,
        Img_Icon = nil,
        Txt_Name = nil
      },
      Group_On = {
        self = nil,
        Img_BG = nil,
        Group_ = {
          self = nil,
          Img_Icon = nil,
          Txt_Name = nil
        }
      }
    }
  }
}
return BuildingShop
