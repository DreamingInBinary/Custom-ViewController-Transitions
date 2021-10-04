# Custom View Controller Transitions
This project explains and shows how to make custom view controller transitions in the most simple way possible. Each example builds off of each other.

## Objects you make

1. Transitioning delegate (Required)
An object whose sole job is to vend either custom animators, presentation
controllers, interactive animators or all of those to UIKit. Setting a custom transitioning delegate for a controllers'
transitioningDelegate property is what tells UIKit you want to perform a 
custom controller transition.

2. Animator _or_ both an Animator and Interactive Animator (Optional)
This decides the duration of the custom transition and performs the actual
animations of the presented view during both presentation and dismissal. It does
*not* decide the final frame of the presented view. Presentation controllers do.
If it an interactive animator is created, it's only job is to calculate how much
of the transition has been completed.

3. Presentation Controller (Optional)
This manages chrome outside of the presented or presenting 
view controllers and can animate those, such as a dimmer view. It also decides 
the final size of the presented view controller's view. It also can respond 
to changes occur in the app’s environment.

## Objects UIKit makes

1. Tranistion Context
Contains all key components of the transition, like to the to and from view controllers.

2. Transition Coordinator
Used to hook into transitions and their animations to perform any other animations or 
changes on existing controllers. For example, if you wanted to animate the deselection 
of a table row in a root view controller on a navigation stack, you'd hook into the controller's
transition coordinator to animate alongside a popped controller's presentation and dismissal.
Much the same way, a presentation controller animates chrome using the presented controller's
transition coordinator too.

## Performing the Custom Transition

1. Initialize the view controller to be presented.
2. Assign your transitioning delegate to the controller’s transitioningDelegate property. Using it, return either
    2a) Custom animator or interactive animator.
    2b) A custom presentation controller. Requires that the controller's modal presentation style is set to custom.
    2c) Or both.
3. Call presentViewController:animated:completion.
