from time import sleep
import piface.pfio as pfio
pfio.init()
pfio.digital_write(3,1) # turn on
pfio.digital_write(4,1) # turn on
pfio.digital_write(5,1) # turn on
sleep(1)
pfio.digital_write(3,0) # turn off
#pfio.digital_write(4,0) # turn on
pfio.digital_write(5,0) # turn on
sleep(2)
pfio.digital_write(3,1) # turn on
pfio.digital_write(4,0) # turn on
pfio.digital_write(5,1) # turn on
sleep(1)
pfio.digital_write(3,0) # turn off
#pfio.digital_write(4,0) # turn on
pfio.digital_write(5,0) # turn on
