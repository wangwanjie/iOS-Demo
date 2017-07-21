
import UIKit

//MARK: UIView动画扩展,d3开头的都是带动画的
var DEFAULT_DURATION:TimeInterval = 0.25
typealias CompleteBlock = (() -> Void)?
extension UIView{
    
    var left:CGFloat{
        set{
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
        get{
            return self.frame.origin.x
        }
    }
    
    var top:CGFloat{
        set{
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
        get{
            return self.frame.origin.y
        }
    }
    
    var right:CGFloat{
        set{
            var frame = self.frame
            frame.origin.x = newValue - frame.size.width
            self.frame = frame
        }
        get{
            return self.frame.origin.x + self.frame.size.width
        }
    }
    
    var bottom:CGFloat{
        set{
            var frame = self.frame;
            frame.origin.y = newValue - frame.size.height
            self.frame = frame
        }
        get{
            return self.frame.origin.y + self.frame.size.height
        }
    }
    
    var centerX:CGFloat{
        set{
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
        get{
            return self.center.x
        }
    }
    
    var centerY:CGFloat{
        set{
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
        get{
            return self.center.y
        }
    }
    
    var width:CGFloat{
        set{
            var frame = self.frame;
            frame.size.width = newValue
            self.frame = frame
        }
        get{
            return self.frame.size.width
        }
    }
    
    var height:CGFloat{
        set{
            var frame = self.frame;
            frame.size.height = newValue
            self.frame = frame
        }
        get{
            return self.frame.size.height
        }
    }
    
    var origin:CGPoint{
        set{
            var frame = self.frame;
            frame.origin = newValue
            self.frame = frame
        }
        get{
            return self.frame.origin
        }
    }
    
    var size:CGSize{
        set{
            var frame = self.frame;
            frame.size = newValue
            self.frame = frame
        }
        get{
            return self.frame.size
        }
    }
    
    
    //MARK: 动画效果基础类
    /**
     加入动画效果
     
     - parameter type:     
     fade     //交叉淡化过渡(不支持过渡方向)
     push     //新视图把旧视图推出去
     moveIn   //新视图移到旧视图上面
     reveal   //将旧视图移开,显示下面的新视图
     cube     //立方体翻滚效果
     oglFlip  //上下左右翻转效果
     suckEffect   //收缩效果，如一块布被抽走(不支持过渡方向)
     rippleEffect //滴水效果(不支持过渡方向)
     pageCurl     //向上翻页效果
     pageUnCurl   //向下翻页效果
     cameraIrisHollowOpen  //相机镜头打开效果(不支持过渡方向)
     cameraIrisHollowClose //相机镜头关上效果(不支持过渡方向)
     
     
     - parameter subType:  
     kCATransitionFromRight
     kCATransitionFromLeft
     kCATransitionFromTop
     kCATransitionFromBottom
     
     
     - parameter duration: 动画持续时间
     */
    func d3_Animation(_ type:String,subType:String!,duration:TimeInterval){
        let action:CATransition = CATransition()
        action.type = type
        if subType != nil{
            action.subtype = subType
        }
        action.duration = duration
        self.layer.add(action, forKey: "animation")
    }
    
    //转场类
    func d3_Animation(_ duration:TimeInterval,transition:UIViewAnimationTransition,forView:UIView,completion:CompleteBlock){
        UIView.animate(withDuration: duration, animations: {
            UIView.setAnimationTransition(transition, for: forView, cache: true)
            }, completion: {(finished) in
                completion?()
        })
    }
    
    //停止所有动画
    func d3_removeAnimate(){
        self.layer.removeAllAnimations()
    }
    
    //角度转弧度
    func degreesToRadians(_ angle:CGFloat)->CGFloat
    {
        return CGFloat(Double(angle) * M_PI / 180)
    }
    
    
    func d3_setX(_ x:CGFloat,completion:CompleteBlock){
        self.d3_setX(x, duration: DEFAULT_DURATION, completion: completion)
    }
    
    
    func d3_setX(_ x:CGFloat,duration:TimeInterval,completion:CompleteBlock){
        UIView.animate(withDuration: duration, animations: {
            self.left = x
            }, completion: {(finished) in
                completion?()
        })
    }
    
    
    func d3_setY(_ y:CGFloat,completion:CompleteBlock){
        self.d3_setY(y, duration: DEFAULT_DURATION, completion: completion)
    }
    
    
    func d3_setY(_ y:CGFloat,duration:TimeInterval,completion:CompleteBlock){
        UIView.animate(withDuration: duration, animations: {
            self.top = y
        }, completion: {(f) in
                completion?()
        })
    }
    
    
    func d3_setRotate(_ angle:CGFloat,completion:CompleteBlock){
        self.d3_setRotate(angle, duration: DEFAULT_DURATION, completion: completion)
    }
    
    /**
     *  旋转
     *
     *  @param duration   用时
     *  @param angle      角度， 为-1的时候一直转.  0~180
     *  @param completion 完成block
     */
    func d3_setRotate(_ angle:CGFloat,duration:TimeInterval,completion:CompleteBlock){
        var options:UIViewAnimationOptions!
        var angle = angle
        if angle == -1 {
            angle = 180
            options = [.repeat, .curveLinear]
        }
        else{
            options = UIViewAnimationOptions.curveLinear
        }
        
        UIView.animate(withDuration: duration ,delay:0 ,options:options ,animations: {
            self.transform = CGAffineTransform(rotationAngle: self.degreesToRadians(angle))
        },completion:{(finished) in
            completion?()
        })
    }
    
    
    func d3_setPoint(_ point:CGPoint,duration:TimeInterval,completion:CompleteBlock){
        UIView.animate(withDuration: duration, animations: {
            self.origin = point
        }, completion: {(finished) in
            completion?()
        })
    }
    
    func d3_setPoint(_ point:CGPoint,completion:CompleteBlock){
        self.d3_setPoint(point, duration: DEFAULT_DURATION, completion: completion)
    }
    
    
    //在原来基础上移动
    func d3_moveX(_ x:CGFloat,duration:TimeInterval,completion:CompleteBlock){
        self.d3_setX(self.frame.origin.x+x, duration: duration, completion: completion)
    }
    
    func d3_moveX(_ x:CGFloat,completion:CompleteBlock){
        self.d3_moveX(x, duration: DEFAULT_DURATION, completion: completion)
    }
    
    func d3_moveY(_ y:CGFloat,duration:TimeInterval,completion:CompleteBlock){
        self.d3_setY(self.frame.origin.y+y, duration: duration, completion: completion)
    }
    
    func d3_moveY(_ y:CGFloat,completion:CompleteBlock){
        self.d3_moveY(y, duration: DEFAULT_DURATION, completion: completion)
    }
    
    
    
    //MARK: 左右摇
    /**
     左右摇动
     
     - parameter range:      摇动幅度
     - parameter duration:       摇动时间
     - parameter completion: 完成block
     */
    func d3_shake(_ range:CGFloat,duration:TimeInterval,completion:CompleteBlock){
        self.d3_moveX(-range, duration: duration, completion: {
            self.d3_moveX(range*2, duration: duration,completion: {
                self.d3_moveX(-range*2, duration: duration, completion: {
                    self.d3_moveX(range,  duration: duration,completion: {
                        completion?()
                    })
                })
            })
        })
    }
    
    func d3_shake(){
        self.d3_shake(10.0,duration: DEFAULT_DURATION,completion: nil)
    }
    
    //MARK: 上下摇
    /**
     上下摇
     
     - parameter range:    摇动幅度
     - parameter duration:   摇动时间
     - parameter finish: 完成block
     */
    func d3_bounce(_ range:CGFloat,duration:TimeInterval,completion:CompleteBlock){
        self.d3_moveY(-range, duration: duration, completion: {
            self.d3_moveY(range, duration: duration, completion: {
                self.d3_moveY(-(range/2), duration: duration, completion: {
                    self.d3_moveY(range/2, duration: duration, completion: {
                        completion?()
                    })
                })
            })
        })
    }
    
    
    func d3_bounce(){
        self.d3_bounce(10.0,duration: DEFAULT_DURATION,completion: nil)
    }
    
    
    //MARK: 心跳
    /**
     心跳
     
     - parameter range:  幅度
     - parameter duration:   时间
     - parameter finish: 完成block
     */
    func d3_heartbeat(_ range:CGFloat,duration:TimeInterval,completion:CompleteBlock){
        UIView.animate(withDuration: duration, animations: {
            self.transform = CGAffineTransform(scaleX: range, y: range)
            }, completion: {(f) in
                UIView.animate(withDuration: duration, delay: 0.1 as TimeInterval, options: [.layoutSubviews,.curveEaseOut], animations: {
                    self.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: {(f) in
                        completion?()
                })
        })
    }
    
    func d3_heartbeat(){
        self.d3_heartbeat(1.2,duration: 0.5,completion: nil)
    }
    
    
    //MARK: 摇摆
    /**
     摇摆
     
     - parameter finish: 完成block
     */
    func d3_swing(_ range:CGFloat,duration:TimeInterval, completion:CompleteBlock){
        self.d3_setRotate(range, duration: duration) { 
            self.d3_setRotate(-range, duration: duration, completion: { 
                self.d3_setRotate(range/2, duration: duration, completion: { 
                    self.d3_setRotate(0, duration: duration, completion: { 
                        completion?()
                    })
                })
            })
        }
    }
    
    func d3_swing(){
        self.d3_swing(15, duration: DEFAULT_DURATION, completion: nil)
    }
    
    
    //MARK: 放大缩小
    /**
     整体放大缩小
     */
    func d3_scale(_ scale:CGFloat,duration:TimeInterval, finish:CompleteBlock){
        UIView.animate(withDuration: duration, animations: { 
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        }) 
    }
    
    func d3_scale(_ scale:CGFloat){
        self.d3_scale(scale, duration: DEFAULT_DURATION, finish: nil)
    }
    
    /**
     宽放大缩小
     */
    func d3_scaleX(_ scale:CGFloat,duration:TimeInterval, finish:CompleteBlock){
        UIView.animate(withDuration: duration, animations: {
            self.transform = CGAffineTransform(scaleX: scale, y: 1)
        }) 
    }
    
    func d3_scaleX(_ scale:CGFloat){
        self.d3_scaleX(scale, duration: DEFAULT_DURATION, finish: nil)
    }
    
    /**
     高放大缩小
     */
    func d3_scaleY(_ scale:CGFloat,duration:TimeInterval, finish:CompleteBlock){
        UIView.animate(withDuration: duration, animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: scale)
        }) 
    }
    
    func d3_scaleY(_ scale:CGFloat){
        self.d3_scaleY(scale, duration: DEFAULT_DURATION, finish: nil)
    }
    

    
    //MARK: 掉落
    func d3_drop(_ duration:TimeInterval, completion:CompleteBlock){
        //移动锚点
        let point = CGPoint(x: self.frame.origin.x, y: self.frame.origin.y)
        self.layer.anchorPoint = CGPoint(x: 0, y: 0)
        self.center = point
        
        self.d3_setRotate(80, duration: duration, completion: {
            self.d3_setRotate(70, duration: duration, completion: {
                self.d3_setRotate(80, duration: duration, completion: {
                    self.d3_setRotate(70, duration: duration, completion: {
                        UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { 
                                self.top = UIScreen.main.bounds.height
                            }, completion: { (finished) in
                                completion?()
                        })
                        
                    })
                })
            })
        })
    }
    
    func d3_drop(){
        self.d3_drop(0.5, completion: nil)
    }
    
    //MARK: 翻转
    func d3_flip(_ duration:TimeInterval, completion:CompleteBlock){
        self.d3_Animation(duration,transition: UIViewAnimationTransition.flipFromLeft,forView: self, completion: completion)
    }
    
    func d3_flip(){
        self.d3_flip(1.0, completion: nil)
    }
    
    
    //MARK: 翻页
    func d3_pageing(_ duration:TimeInterval, completion:CompleteBlock){
        self.d3_Animation(duration,transition: UIViewAnimationTransition.curlUp,forView: self, completion: completion)
    }
    
    func d3_pageing(){
        self.d3_pageing(1.0, completion: nil)
    }
    
    
    //MARK: 闪,呼吸灯
    func d3_blink(_ duration:TimeInterval){
        UIView.animate(withDuration: duration, delay: 0, options: [.repeat, .autoreverse], animations: { 
            self.alpha = 0;
        }, completion: nil)
    }
    
    func d3_blink(){
        self.d3_blink(0.5)
    }
    
    //MARK: 渐隐
    func d3_fadeOut(_ duration:TimeInterval,completion:CompleteBlock){
        UIView.animate(withDuration: duration, animations: { 
            self.alpha = 0
        }, completion: {(finished) in
            completion?()
        })
    }
 
    func d3_fadeOut(){
        self.d3_fadeOut(0.5, completion: nil)
    }
    
    //MARK: 渐现
    func d3_fadeIn(_ duration:TimeInterval,completion:CompleteBlock){
        self.isHidden = false
        self.alpha = 0
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1
        }, completion: {(finished) in
            completion?()
        })
    }
    
    func d3_fadeIn(){
        self.d3_fadeIn(0.5, completion: nil)
    }
    
}// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
