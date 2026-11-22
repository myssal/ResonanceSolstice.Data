local CardBooklet = {
  self = nil,
  Img_Bg = nil,
  Group_CommonTopLeft = {
    self = nil,
    Btn_Return = nil,
    Btn_Home = nil,
    Btn_Menu = nil,
    Btn_Help = {
      self = nil,
      Group_Txt = {
        self = nil,
        Img_icon = nil,
        Txt_ = nil
      }
    }
  },
  Group_Booklet = {
    self = nil,
    ScrollGrid_Booklet = {
      self = nil,
      grid = {
        self = nil,
        Group_Booklet = {
          self = nil,
          Img_Cover = nil,
          Img_All = nil,
          Group_Series = {
            self = nil,
            Img_Series = nil,
            Txt_SeriesName = nil,
            Group_Num = {
              self = nil,
              Txt_CollectedNum = nil,
              Txt_ = nil,
              Txt_AllNum = nil
            }
          },
          Btn_ = nil
        }
      }
    },
    Page_Booklet = {
      self = nil,
      grid = {
        self = nil,
        Group_Booklet = {
          self = nil,
          Img_Cover = nil,
          Img_All = nil,
          Group_Series = {
            self = nil,
            Img_Series = nil,
            Txt_SeriesName = nil,
            Group_Num = {
              self = nil,
              Txt_CollectedNum = nil,
              Txt_ = nil,
              Txt_AllNum = nil
            }
          },
          Btn_ = nil
        }
      }
    }
  },
  CustomScrollGrid_List = {
    self = nil,
    grid = {
      self = nil,
      Group_Title = {
        self = nil,
        Img_Rectangle = nil,
        Txt_SeriesName = nil
      },
      StaticGrid_Card = {
        self = nil,
        grid = {
          self = nil,
          Btn_Card = {self = nil, Img_Card = nil},
          Btn_CardBack = {self = nil, Img_CardBack = nil}
        }
      }
    }
  },
  Img_Bottom = nil,
  Group_BottomLeft = {
    self = nil,
    Img_Icon = nil,
    Txt_Title = nil,
    Txt_Collected = nil,
    Group_Num = {
      self = nil,
      Txt_CollectedNum = nil,
      Txt_ = nil,
      Txt_AllNum = nil
    }
  },
  Group_BottomRight = {
    self = nil,
    Img_TabBack = nil,
    Group_BookletFormat = {
      self = nil,
      Group_Off = {
        self = nil,
        Img_Icon = nil,
        Txt_Booklet = nil
      },
      Group_On = {
        self = nil,
        Img_Bg = nil,
        Img_Icon = nil,
        Txt_Booklet = nil
      },
      Btn_Switch = nil
    },
    Group_ListFormat = {
      self = nil,
      Group_Off = {
        self = nil,
        Img_Icon = nil,
        Txt_Booklet = nil
      },
      Group_On = {
        self = nil,
        Img_Bg = nil,
        Img_Icon = nil,
        Txt_Booklet = nil
      },
      Btn_Switch = nil
    }
  }
}
return CardBooklet
