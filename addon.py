import os

import xbmc
import xbmcaddon
import xbmcgui
import xbmcplugin

addon = xbmcaddon.Addon()
addonname = addon.getAddonInfo('name')

xbmc.executebuiltin('ActivateWindow(busydialog)')

os.system("echo 'RetroArch [ADDON] ::' $(date) > /storage/.kodi/temp/retroarch.log")
os.system("echo '======================' >> /storage/.kodi/temp/retroarch.log")

os.system("mkdir -p /storage/.kodi/userdata/addon_data/game.retroarch")
os.system("if [ -L /storage/.config/retroarch ] ; then rm -rf /storage/.config/retroarch ; fi")
os.system("ln -s /storage/.kodi/userdata/addon_data/game.retroarch /storage/.config/retroarch")

os.system("chmod a+x /storage/.kodi/addons/game.retroarch/addon.sh")
os.system("chmod a+x /storage/.kodi/addons/game.retroarch/addon.start")
os.system("chmod a+x /storage/.kodi/addons/game.retroarch/game.retroarch")

askConfirmation = xbmcplugin.getSetting(int(sys.argv[1]), 'ask')
runConfirmation = True

if askConfirmation == "true":
  runConfirmation = xbmcgui.Dialog().yesno("RetroArch", "Exit Kodi and run RetroArch?")

if runConfirmation:
  xbmc.executebuiltin('ShowPicture("/storage/.kodi/addons/game.retroarch/resources/fanart.jpg")')
  xbmc.executebuiltin('ActivateWindow(busydialog)')

  os.system("echo 'RetroArch [ADDON] :: Kodi is ready.' >> /storage/.kodi/temp/retroarch.log")
  os.system("sh /storage/.kodi/addons/game.retroarch/addon.sh")
else:
  os.system("echo 'RetroArch [ADDON] :: Abort launch.' >> /storage/.kodi/temp/retroarch.log")
