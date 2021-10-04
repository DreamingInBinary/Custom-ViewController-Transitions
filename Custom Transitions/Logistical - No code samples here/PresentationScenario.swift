//
//  PresentationScenario.swift
//  Custom Transitions
//
//  Created by Jordan Morgan on 10/1/21.
//

import Foundation

// Future examples: UINavigationController, subclassed UIPercentDrivenInteractiveTransition and UIViewPropertyAnimator
struct PresentationScenario: Hashable {
    let id = UUID()
    let name: String
    let info: String
    static let all: [PresentationScenario] = [PresentationScenario(name: "Just Coordinator", info: "This hooks into this controller's UIViewControllerTransitionCoordinator to do some animation alongside another controller's presentation. In this case, it'll animate the background turning red as the new controller presents.\n\nTL;DR This lets you do arbitrary animations in lockstep with another presentation or dismissal."),
                                              PresentationScenario(name: "Just Animator", info: "Here, we have our transitioning delegate vend only an animator - which conforms to UIViewControllerAnimatedTransitioning. With it, we get what the final frame should be of the presented view - but are free to animate it to that CGRect any way we want. Also, we can set a starting rect. Here, we make it animate from the bottom right, up to center. It dismisses the same way.\n\nTL;DR This decides how to animate the presented view to its final CGRect."),
                                              PresentationScenario(name: "Just Presentation Controller", info: "In this case, a custom UIPresentationController is used. A presentation controller is typically used for two things (though it can do more); A) Animating \"chrome\" outside of the two controllers such as a dimming view and B) Calculating the final frame of the presented controller's view. So here, our transitioning delegate only vends a presentation controller which then tells UIKit that the presented controller's frame should be half of the width of the container view, positioned on the right half of the screen. It also animates a dimming view behind it all.\n\nTL;DR This can size the presented view, but doesn't control its animations, but it *can* animate chrome outside of the presenting or presented controller."),
        PresentationScenario(name: "Animator and Presentation Controller", info: "This is the most common use of the API. Here, the transitioning delegate returns both a custom animator object and a presentation controller. This means we can fully control every aspect of the transition. The presentation controller will tell the animator where to put the presented view, the animator will be in charge of animating it there and the presentation controller will also manage a dimming view (i.e. extra \"chrome\").\n\nTL;DR This is the most common way to do custom transitions. Create a custom transitioning delegate which tells UIKit which animator and presentation controller to use."),
                                              PresentationScenario(name: "Add Interactive Animator", info: "This is the same exact scenario as above, save for the fact that we can now use a custom UIGestureRecognizer to drive the completion percentage of the animation via UIViewControllerInteractiveTransitioning. This protocol is actually what makes a stock UINavigationController pop and push transition interactive. \n\nThis custom transition works the same way as above, except now using a UIPercentDrivenInteractiveTransition (which implements the aforementioned protocol for us) object vended in the transitioning delegate, we set up the event handling code needed to determine a completion percentage for the transition and update it accordingly. To use this, swipe down on the dimming view after presentation to kick off an interactive dismissmal.\n\nTL;DR This uses all the objects we've made so far, but adds one more object to calculate the completion percentage of a dismissal from a pan gesture, which drives the dismissal itself.")]
}
