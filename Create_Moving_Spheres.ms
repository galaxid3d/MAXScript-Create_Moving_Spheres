-- Date: 26.03.2016 by galaxid3d
-- This script creates a specified number of spheres inside a given area (you can select a box), then animates their movements and collisions with the walls of the box and among themselves

rollout SpheresCreateAnimationRollout "Create Spheres Animation" width:260 height:290 (
	GroupBox 'Position_grp' "Position" pos:[2,2] width:255 height:75
	spinner 'x_min_spnr' "X_min:" pos:[6,17] width:110 height:16 range:[-1e+008,1e+008,-100] type:#float scale:0.1 align:#left
	spinner 'y_min_spnr' "Y_min:" pos:[6,37] width:110 height:16 range:[-1e+008,1e+008,-100] type:#float scale:0.1 align:#left
	spinner 'z_min_spnr' "Z_min:" pos:[6,57] width:110 height:16 range:[-1e+008,1e+008,-100] type:#float scale:0.1 align:#left
	spinner 'x_max_spnr' "X_max:" pos:[130,17] width:110 height:16 range:[-1e+008,1e+008,100] type:#float scale:0.1 align:#left
	spinner 'y_max_spnr' "Y_max:" pos:[130,37] width:110 height:16 range:[-1e+008,1e+008,100] type:#float scale:0.1 align:#left
	spinner 'z_max_spnr' "Z_max:" pos:[130,57] width:110 height:16 range:[-1e+008,1e+008,100] type:#float scale:0.1 align:#left
	GroupBox 'Speed_grp' "Speed" pos:[2,80] width:255 height:75
	spinner 'Sx_min_spnr' "Sx_min:" pos:[6,95] width:110 height:16 range:[-1e+008,1e+008,-10] type:#float scale:0.1 align:#left
	spinner 'Sy_min_spnr' "Sy_min:" pos:[6,115] width:110 height:16 range:[-1e+008,1e+008,-10] type:#float scale:0.1 align:#left
	spinner 'Sz_min_spnr' "Sz_min:" pos:[6,135] width:110 height:16 range:[-1e+008,1e+008,-10] type:#float scale:0.1 align:#left
	spinner 'Sx_max_spnr' "Sx_max:" pos:[130,95] width:110 height:16 range:[-1e+008,1e+008,10] type:#float scale:0.1 align:#left
	spinner 'Sy_max_spnr' "Sy_max:" pos:[130,115] width:110 height:16 range:[-1e+008,1e+008,10] type:#float scale:0.1 align:#left
	spinner 'Sz_max_spnr' "Sz_max:" pos:[130,135] width:110 height:16 range:[-1e+008,1e+008,10] type:#float scale:0.1 align:#left
	GroupBox 'Create_Properties_grp' "Create Properties" pos:[2,155] width:255 height:75
	spinner 'size_min_spnr' "Size_min:" pos:[6,170] width:102 height:16 range:[0,1e+008,2] type:#float scale:0.1 align:#left
	spinner 'size_max_spnr' "Size_max:" pos:[132,170] width:102 height:16 range:[0,1e+008,10] type:#float scale:0.1 align:#left
	spinner 'Count_spnr' "Count:" pos:[6,190] width:68 height:16 range:[0,1e+008,10] type:#integer scale:1 align:#left
	spinner 'SphereSegments_spnr' "Segs:" pos:[97,190] width:48 height:16 range:[4,200,16] type:#integer scale:1 align:#left
	spinner 'Random_seed_spnr' "Seed" pos:[167,190] width:74 height:16 range:[0,1e+006,12345] type:#integer scale:1 align:#left
	checkbox 'DeleteObjects_inScene_chk' "Delete Objects in Scene" pos:[4,210] width:134 height:16 checked:false
	checkbox 'Create_Limit_Box_chk' "Create_Limit_Box" pos:[147,210] width:105 height:16 checked:true
	button 'Create_Spheres_Animation_btn' "Create Spheres Animation" pos:[6,235] width:248 height:50
	
	fn Create_Spheres_Animation x_min x_max y_min y_max z_min z_max Sx_min Sx_max Sy_min Sy_max Sz_min Sz_max size_min size_max = ( suspendEditing()
		seed SpheresCreateAnimationRollout.Random_seed_spnr.value
		frameRate = 24
		a=#(); a[SpheresCreateAnimationRollout.Count_spnr.value]=0 --array all spheres: 1parameter - position [ x_pos,y_pos,z_pos ], 2 - speed [x, y, z], 3 - size
		if SpheresCreateAnimationRollout.DeleteObjects_inScene_chk.checked then delete objects
		for i = 1 to SpheresCreateAnimationRollout.Count_spnr.value do (
			a[i] = #([random (x_min+size_max) (x_max-size_max), random (y_min+size_max) (y_max-size_max), random (z_min+size_max) (z_max-size_max)], [random Sx_min Sx_max, random Sy_min Sy_max, random Sz_min Sz_max], random size_min size_max)
			sphere radius:a[i][3] segs:SpheresCreateAnimationRollout.SphereSegments_spnr.value pos:a[i][1] wirecolor:(color (random 0 255) (random 0 255) (random 0 255) )
		)
		set animate on
		with redraw off for f = animationRange.start to animationRange.end do ( -- all frames in scene
			for i = 1 to SpheresCreateAnimationRollout.Count_spnr.value do (
				a[i][1][1] += a[i][2][1] -- add speed on position
				a[i][1][2] += a[i][2][2]
				a[i][1][3] += a[i][2][3]
				
				if ((a[i][1][1]+a[i][3]>=x_max) or (a[i][1][2]+a[i][3]>=y_max) or (a[i][1][3]+a[i][3]>=z_max)) or -- collisions with walls
					((a[i][1][1]-a[i][3]<=x_min) or (a[i][1][2]-a[i][3]<=y_min) or (a[i][1][3]-a[i][3]<=z_min)) then (
					a[i][2][1] = -a[i][2][1]
					a[i][2][2] = -a[i][2][2]
					a[i][2][3] = -a[i][2][3]
					
					a[i][1][1] += a[i][2][1] -- add speed on position
					a[i][1][2] += a[i][2][2]
					a[i][1][3] += a[i][2][3]
				)
				
				for j = i+1 to SpheresCreateAnimationRollout.Count_spnr.value do (
					if ((sqr(a[i][1][1]-a[j][1][1]) + sqr(a[i][1][2]-a[j][1][2]) + sqr(a[i][1][3]-a[j][1][3]))<sqr(a[i][3]+a[j][3])) then (
						a[i][2][1] = ((abs(a[j][3])-abs(a[i][3]))*a[j][2][1]+2*(abs(a[i][3])*a[i][2][1]))/(abs(a[i][3])+abs(a[j][3]))
						a[i][2][2] = ((abs(a[j][3])-abs(a[i][3]))*a[j][2][2]+2*(abs(a[i][3])*a[i][2][2]))/(abs(a[i][3])+abs(a[j][3]))
						a[i][2][3] = ((abs(a[j][3])-abs(a[i][3]))*a[j][2][3]+2*(abs(a[i][3])*a[i][2][3]))/(abs(a[i][3])+abs(a[j][3]))
						
						a[j][2][1] = ((abs(a[i][3])-abs(a[j][3]))*a[i][2][1]+2*(abs(a[j][3])*a[j][2][1]))/(abs(a[i][3])+abs(a[j][3]))
						a[j][2][2] = ((abs(a[i][3])-abs(a[j][3]))*a[i][2][2]+2*(abs(a[j][3])*a[j][2][2]))/(abs(a[i][3])+abs(a[j][3]))
						a[j][2][3] = ((abs(a[i][3])-abs(a[j][3]))*a[i][2][3]+2*(abs(a[j][3])*a[j][2][3]))/(abs(a[i][3])+abs(a[j][3]))
						
						a[i][1][1] += a[i][2][1] -- add speed on position
						a[i][1][2] += a[i][2][2]
						a[i][1][3] += a[i][2][3]
						
						a[j][1][1] += a[j][2][1] -- add speed on position
						a[j][1][2] += a[j][2][2]
						a[j][1][3] += a[j][2][3]
					)
				)
				at time f objects[abs(objects.count-i)+1].pos = a[i][1] -- add keyframe position only (" [3][1]") ("[3] - all parameters", " [3][2] " - rotation only etc.)
			)
		)
		set animate off
		sliderTime = 0f
		if SpheresCreateAnimationRollout.Create_Limit_Box_chk.checked then (
			box_limited = box name:(uniqueName "LimitBox") Width:(abs(x_min-x_max)) Length:(abs(y_min-y_max)) Height:(abs(z_min-z_max)) pos:[0.5 * (x_min + x_max), 0.5 * (y_min + y_max), z_min] box_limited.xray = true
			select box_limited 
			max box mode selected --Display as Box
			clearSelection()
		)
	resumeEditing() )
	
	on Random_seed_spnr changed val do with redraw off
		Create_Spheres_Animation x_min_spnr.value x_max_spnr.value y_min_spnr.value y_max_spnr.value z_min_spnr.value z_max_spnr.value Sx_min_spnr.value Sx_max_spnr.value Sy_min_spnr.value Sy_max_spnr.value Sz_min_spnr.value Sz_max_spnr.value size_min_spnr.value size_max_spnr.value

	on Create_Spheres_Animation_btn pressed do (
		SpheresCreateAnimationRollout.Random_seed_spnr.value=random 0 1e+006
		Random_seed_spnr.changed Random_seed_spnr.value
	)
)
createDialog SpheresCreateAnimationRollout style:#(#style_minimizebox, #style_titlebar, #style_border, #style_sysmenu)