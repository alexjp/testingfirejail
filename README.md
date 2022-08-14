# testingfirejail


Add dotconfig/plasma-workspace/env files to ~/.config/plasma-workspace/env (this will make the activity aware bin's be visible on plasma)

Copy activities to your $HOME, for example


# To add an app (dolphin for ex), on activities/bin do a `ln -s fj.sh dolphin`

# To make one activity not be isolated, create a file in activities with a dot and the activities uuid ( ex: activities/.b1633b30-2bc7-4830-bebb-98f4ad83cad1 )
