local Aquarium = {
  self = nil,
  Img_B = nil,
  Img_BG = nil,
  Img_BGMask = nil,
  Group_NPCPos = {
    self = nil,
    Group_NPC = {
      self = nil,
      Img_Role = nil,
      SpineAnimation_Character = nil,
      SpineAnimation_Alpha = nil,
      Img_Dialog = {self = nil, Txt_Talk = nil},
      Img_Name = {self = nil, Txt_Name = nil}
    }
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
  Group_Main = {
    self = nil,
    Btn_Buy = {
      self = nil,
      Txt_Name = nil,
      Img_Icon = nil
    },
    Btn_Talk = {
      self = nil,
      Txt_Name = nil,
      Img_Icon = nil,
      Img_RedPoint = nil
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
  Group_Store = {
    self = nil,
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
    Group_Resources = {
      self = nil,
      Group_GoldCoin = {
        self = nil,
        Img_BG = nil,
        Btn_GoldCoin = nil,
        Img_Icon = nil,
        Txt_Num = nil
      }
    },
    Group_NpcInfoL = {
      self = nil,
      Txt_Title = nil,
      Img_Icon = nil,
      Group_Station = {
        self = nil,
        Img_Icon = nil,
        Txt_Station = nil
      },
      Img_Line = nil,
      Btn_Refresh = nil
    },
    Img_BG = {
      self = nil,
      Img_ = nil,
      Img_TitleIcon = nil,
      Img_Title = nil,
      Txt_Title = nil
    },
    Img_SellBG = {
      self = nil,
      Img_ = nil,
      Img_TitleIcon = nil,
      Img_Title = nil,
      Txt_Title = nil
    },
    Group_Buy = {
      self = nil,
      Group_General = {
        self = nil,
        ScrollGrid_List = {
          self = nil,
          grid = {
            self = nil,
            Img_BG = nil,
            Btn_1 = nil,
            Img_Mask = {self = nil, Img_Item = nil},
            Txt_Name = nil,
            Group_Money = {
              self = nil,
              Group_Money = {self = nil, Img_Money = nil},
              Txt_MoneyNum = nil
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
              },
              Group_AttributeLove = {
                self = nil,
                Img_AttributeIcon = nil,
                Txt_Scores = nil
              }
            },
            Img_ShouWan = {
              self = nil,
              Img_ = {
                self = nil,
                Txt_ = nil,
                Txt_EN = nil
              }
            },
            Img_Picked = {self = nil, Txt_ = nil}
          }
        },
        Btn_PL = {
          self = nil,
          Group_On = {
            self = nil,
            Img_ = nil,
            Txt_ = nil
          },
          Group_Off = {
            self = nil,
            Img_ = nil,
            Txt_ = nil
          }
        },
        Group_Time = {
          self = nil,
          Img_ = nil,
          Btn_ShuaXin = {self = nil, Txt_ = nil},
          Btn_ = {self = nil, Txt_ = nil},
          Txt_All = nil,
          Group_Money = {
            self = nil,
            Group_Money = {self = nil, Img_Money = nil},
            Txt_MoneyNum = nil
          },
          Txt_Time = nil
        }
      }
    },
    Group_Sell = {
      self = nil,
      Group_General = {
        self = nil,
        ScrollGrid_List = {
          self = nil,
          grid = {
            self = nil,
            Img_BG = nil,
            Btn_1 = nil,
            Img_Mask = {self = nil, Img_Item = nil},
            Txt_Name = nil,
            Group_Money = {
              self = nil,
              Group_Money = {self = nil, Img_Money = nil},
              Txt_MoneyNum = nil
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
              },
              Group_AttributeLove = {
                self = nil,
                Img_AttributeIcon = nil,
                Txt_Scores = nil
              }
            },
            Group_SY = {
              self = nil,
              Img_1 = {
                self = nil,
                Txt_NumDes = nil,
                Txt_Num = nil
              }
            },
            Group_Level = {
              self = nil,
              Img_BG = nil,
              Group_Num = {
                self = nil,
                Txt_LV = nil,
                Txt_Num = nil
              }
            },
            Img_Picked = {self = nil, Txt_ = nil}
          }
        },
        Group_Time = {
          self = nil,
          Img_ = nil,
          Btn_ = {self = nil, Txt_ = nil},
          Txt_All = nil,
          Group_Money = {
            self = nil,
            Group_Money = {self = nil, Img_Money = nil},
            Txt_MoneyNum = nil
          }
        },
        Btn_PL = {
          self = nil,
          Group_On = {
            self = nil,
            Img_ = nil,
            Txt_ = nil
          },
          Group_Off = {
            self = nil,
            Img_ = nil,
            Txt_ = nil
          }
        }
      }
    },
    Group_Nothing = {
      self = nil,
      Img_Icon = nil,
      Txt_ = nil
    }
  }
}
return Aquarium
