# Sweet Dream, a sweet metroidvannia
#    Copyright (C) 2022 Kamran Charles Nayebi and William Duplain
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.
extends CanvasLayer

onready var ammo_display := $CurrentAmmo
onready var next_ammo_display := $NextAmmo
onready var health_bar = $Resizer/TextureProgress
onready var sugar_bar = $Resizer/TextureProgress2
onready var health_pack_display = $Resizer/TextureProgress3

func connect_player():
	get_tree().current_scene.player.connect("changed_ammo", self, "_on_changed_ammo")
	get_tree().current_scene.player.connect("changed_health", self, "_on_changed_health")
	get_tree().current_scene.player.connect("changed_sugar", self, "_on_changed_sugar")
	get_tree().current_scene.player.connect("changed_health_pack", self, "_on_changed_health_pack")

func _on_changed_ammo():
	if GlobalVars.ammo_equipped_array.size() != 0:
		if GlobalVars.ammo_equipped_array[GlobalVars.equiped_ammo_index] != null:
			ammo_display.texture = GlobalVars.ammo_equipped_array[GlobalVars.equiped_ammo_index].texture
			if GlobalVars.ammo_equipped_array[(GlobalVars.equiped_ammo_index + 1) % GlobalVars.ammo_equipped_array.size()] != null:
				next_ammo_display.texture = GlobalVars.ammo_equipped_array[(GlobalVars.equiped_ammo_index + 1) % GlobalVars.ammo_equipped_array.size()].texture
			else:
				next_ammo_display.texture = null
		else:
			ammo_display.texture = null

func _on_changed_health():
	# Scaling it in code instead of messing with the textures themselves
	health_bar.value = 88*float(GlobalVars.health)/GlobalVars.max_health + 10

func _on_changed_sugar():
	# Scaling it in code instead of messing with the textures themselves
	sugar_bar.value = 68*float(GlobalVars.sugar)/GlobalVars.max_sugar + 10

func _on_changed_health_pack():
	# Scaling it in code instead of messing with the textures themselves
	if GlobalVars.max_health_packs != 0:
		health_pack_display.value = 22*GlobalVars.health_packs/GlobalVars.max_health_packs + 22
