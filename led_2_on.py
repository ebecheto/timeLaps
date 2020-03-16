from time import sleep
import piface.pfio as pfio
pfio.init()
pfio.digital_write(2,1) # turn on
