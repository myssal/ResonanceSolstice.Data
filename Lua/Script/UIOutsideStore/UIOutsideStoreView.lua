local OutsideStore = {
  self = nil,
  Img_BG = nil,
  Img_Title = nil,
  Group_Coin = {
    self = nil,
    Img_Deco = nil,
    Img_Bg = nil,
    Txt_Num = nil,
    Txt_Des = nil,
    Btn_Tips = nil
  },
  ScrollGrid_Coin = {
    self = nil,
    grid = {
      self = nil,
      Img_ = nil,
      Img_Icon = nil,
      Txt_Num = nil,
      Btn_Tips = nil
    }
  },
  Group_NPC = {
    self = nil,
    Img_Role = nil,
    SpineAnimation_Character = nil,
    SpineAnimation_Alpha = nil,
    Img_Dialog = {self = nil, Txt_Talk = nil},
    Img_Name = {self = nil, Txt_Name = nil},
    Btn_Chat = nil
  },
  ScrollGrid_Commodity = {
    self = nil,
    grid = {
      self = nil,
      Img_Bg = nil,
      Group_CommonItem = {
        self = nil,
        Btn_Item = nil,
        Img_Bottom = nil,
        Img_Item = nil,
        Img_Mask = nil,
        Txt_Num = nil,
        Group_Effect = nil
      },
      Group_Limit = {
        self = nil,
        Txt_ = nil,
        Txt_PurchaseNum = nil
      },
      Txt_Name = nil,
      Group_Price = {
        self = nil,
        Img_Coin = nil,
        Txt_Num = nil
      },
      Img_SoldOut = nil,
      Btn_ = nil
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
return OutsideStore
