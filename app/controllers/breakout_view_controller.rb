class BreakoutViewController < UIViewController
  def viewDidLoad
    view.backgroundColor = UIColor.whiteColor

    width = 100
    height = 15
    @bar = UIView.alloc.initWithFrame([[(view.frame.size.width - width) / 2, view.frame.size.height - height], [width, height]])
    @bar.backgroundColor = UIColor.blueColor

    @barPanGestureRecognizer = UIPanGestureRecognizer.alloc.initWithTarget(self, action:"barPanGesture:")
    @bar.addGestureRecognizer(@barPanGestureRecognizer)

    view.addSubview(@bar)
  end

  def barPanGesture(sender)
    point = sender.translationInView(@bar)
    sender.setTranslation([0, 0], inView:@bar)
    frame = @bar.frame
    frame.origin.x += point.x

    if frame.origin.x < 0
      frame.origin.x = 0
    elsif frame.origin.x > view.frame.size.width - frame.size.width
      frame.origin.x = view.frame.size.width - frame.size.width
    end

    @bar.frame = frame
  end
end