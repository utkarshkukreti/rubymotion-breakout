class BreakoutViewController < UIViewController
  def viewDidLoad
    view.backgroundColor = UIColor.whiteColor

    width = 100
    height = 15
    @bar = UIView.alloc.initWithFrame([[(view.frame.size.width - width) / 2, view.frame.size.height - height], [width, height]])
    @bar.backgroundColor = UIColor.blueColor
    view.addSubview(@bar)
  end
end