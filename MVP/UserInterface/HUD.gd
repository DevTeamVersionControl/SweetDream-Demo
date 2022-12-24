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

onready var ammo_display = $AmmoDisplay
onready var health_bar = $HealthBar
onready var health_pack_display = $HeathPackDisplay

func connect_player():
	get_tree().current_scene.player.connect("changed_ammo", self, "_on_changed_ammo")
	get_tree().current_scene.player.connect("changed_health", self, "_on_changed_health")
	get_tree().current_scene.player.connect("changed_health_pack", self, "_on_changed_health_pack")

func _on_changed_ammo():
	ammo_display.text = GlobalVars.ammo_equipped_array[GlobalVars.equiped_ammo_index].name

func _on_changed_health():
	health_bar.max_value = GlobalVars.max_health
	health_bar.value = GlobalVars.health

func _on_changed_health_pack():
	health_pack_display.text = "Candy:" + String(GlobalVars.health_packs)
