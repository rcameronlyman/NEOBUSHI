extends Resource
class_name MechMovementData

# The "Bulldozer" configuration
export(int) var max_speed = 200        # How fast we eventually go
export(int) var acceleration = 400     # Low = Heavy wind-up to get moving
export(int) var friction = 2000        # High = Stops almost instantly when keys are released
export(float) var turning_torque = 0.1 # How much the torso lags behind the mouse
