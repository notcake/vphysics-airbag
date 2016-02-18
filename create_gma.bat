"../../../bin/gmad.exe" create -folder "." -out "addon.gma"
echo "../../../bin/gmpublish.exe" create -addon addon.gma -icon addon.jpg
echo "../../../bin/gmpublish.exe" update -addon addon.gma -id "591966233" -changes "blargh"
cmd
