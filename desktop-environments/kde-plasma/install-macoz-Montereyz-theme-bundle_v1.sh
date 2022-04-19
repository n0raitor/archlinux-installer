#!/bin/bash
echo "Settings: WorkspaceBehaviour "
echo "-> DesktopEffects -> (Disable Search Filter: Only Supported)"
echo "- Blur (Enable) + Settings: 13 + 10"
echo "- Wobbly Windows (Enable) + Wobbliness (pre last) + Enable Advances Mode"
echo "- Magic Lamp -> 400 MiliSecs"
echo "- Dim Screen for Administrator Mode (enable)"

echo "- Slide Back (enable)"
echo "- Slide (Duration: 600 Milisec)"
echo "- Overview (Enable) + Shortcut: Meta+Ctrl+D"

read -p "Configure like described and press ENTER to continue"

echo "WindowManagement ->"
echo "WindowBehaviour ->"
echo "Titlebar Actions:"
echo "- Advanced: Allow apps ... (disable)"
echo "Task Switcher: Main: Visualization: Select: Large Icons"
echo "KWin Scripts:"
echo "Get New Script:..."
echo "- force blur (install)"
echo "- MACsimize (install 2018)"
echo "- Latte Window Colors"
echo "- Latte Activate Launcher Menu"
echo "ENABLE THOSE SCRIPTS"

read -p "Configure like described and press ENTER to continue"

echo "Notifications:"
echo "- Choose Custom Position: Right Bottom"
echo "Startup and Shutdown:"
echo "-> Desktop Session:"
echo "- When Logging in: Start with an empty session"
echo "Display and Monitor:"
echo "-> Compositor:"
echo "- Scale Method: Smooth"
echo "- Rendering Backend (opt): OpenGL 3.1"

read -p "Configure like described and press ENTER to continue"

pacman -S kvantum

echo "INIT CONFIG DONE"
sleep 3

echo "Appearance "
echo "-> Global Theme:"
echo "- Get New Global Theme: Monterey kde theme + dark"
echo "-> Application:"
echo "- Configure GNOME/GTK Application Style -> Get New..."
echo "-- colloid gtk theme: (Colloid-light)"
echo "Rename Theme (in ~/.themes) to Colloid-light-00, reopen the get new.. and select Colloid-dark, then remove the -00 you just renamed"

read -p "Configure like described and press ENTER to continue"

