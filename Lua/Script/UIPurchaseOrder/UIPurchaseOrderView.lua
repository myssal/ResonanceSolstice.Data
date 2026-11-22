local PurchaseOrder = {
  self = nil,
  Img_BG = nil,
  Img_Mask = nil,
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
  Group_TopRight = {
    self = nil,
    Group_Warehouse = {
      self = nil,
      Img_Bg = nil,
      Txt_0 = nil,
      Img_Icon = nil,
      Img_Bar = {self = nil, Img_Fill = nil},
      Group_Num = {
        self = nil,
        Txt_Own = nil,
        Txt_0 = nil,
        Txt_Max = nil
      }
    },
    Group_OrderNum = {
      self = nil,
      Img_Bg = nil,
      Txt_Num = nil
    }
  },
  Group_Left = {
    self = nil,
    Img_BG = nil,
    Img_Icon = nil,
    Img_Iine = nil,
    Txt_Eng = nil,
    Txt_0 = nil,
    Group_Tips = {
      self = nil,
      Img_Icon = nil,
      Txt_0 = nil
    },
    Btn_BuyOne = {self = nil, Txt_ = nil},
    Btn_CompleteOne = {self = nil, Txt_ = nil}
  },
  NewScrollGrid_Order = {
    self = nil,
    grid = {
      self = nil,
      Group_Show = {
        self = nil,
        Img_BG = nil,
        Group_Title = {self = nil, Txt_Cname = nil},
        Group_Time = {
          self = nil,
          Img_BG = nil,
          Group_Defult = {
            self = nil,
            Txt_Cname = nil,
            Txt_Num = nil,
            Txt_CTime = nil,
            Txt_Time = nil
          },
          Group_Waiting = {
            self = nil,
            Txt_Cname = nil,
            Txt_Num = nil,
            Txt_CTime = nil,
            Txt_Time = nil
          },
          Group_Finish = {
            self = nil,
            Txt_Cname = nil,
            Txt_Num = nil,
            Txt_CTime = nil,
            Txt_Time = nil
          }
        },
        Group_Cost = {
          self = nil,
          Img_BG = nil,
          Group_BG = {
            self = nil,
            Img_BG1 = nil,
            Img_BG2 = nil,
            Img_BG3 = nil
          },
          StaticGrid_CostList = {
            self = nil,
            grid = {
              self = nil,
              Group_Empty = {self = nil, Img_BG = nil},
              Group_Show = {
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
                },
                Group_Num = {
                  self = nil,
                  Txt_Need = nil,
                  Txt_0 = nil,
                  Txt_Own = nil
                }
              }
            }
          },
          Txt_title = nil
        },
        Group_Reward = {
          self = nil,
          Img_BG = nil,
          Btn_Item = {self = nil, Img_Item = nil}
        },
        Group_Defult = {
          self = nil,
          Btn_Buy = {
            self = nil,
            Img_Icon = nil,
            Txt_0 = nil
          }
        },
        Group_Waiting = {
          self = nil,
          Btn_AddSpeed = {
            self = nil,
            Img_Icon = nil,
            Txt_0 = nil
          },
          Group_Bar = {
            self = nil,
            Img_BG = nil,
            Img_Icon = nil,
            Txt_0 = nil,
            Group_Bar = {
              self = nil,
              Img_BarBG = nil,
              Img_Bar = nil
            }
          }
        },
        Group_Finished = {
          self = nil,
          Btn_Get = {
            self = nil,
            Img_Icon = nil,
            Txt_0 = nil
          }
        },
        Group_Rare = {
          self = nil,
          Img_BG = nil,
          Txt_Title = nil,
          StaticGrid_Rare = {self = nil, Img_Star = nil}
        },
        Img_RedDot = nil
      },
      Group_Empty = {
        self = nil,
        Img_BG = nil,
        Img_Mask = nil,
        Btn_Add = {
          self = nil,
          Img_ = nil,
          Txt_Add = nil
        }
      }
    }
  }
}
return PurchaseOrder
