import re
import pygame

with open("res/inputs/day14.txt", "r") as f:
    lines = f.read().split("\n")

bots = []

for line in lines:
    m = re.match("^p=(.*?),(.*?) v=(.*?),(.*?)$", line)
    bot = {
        "pos": {
            "x": int(m.group(1)),
            "y": int(m.group(2)),
        },
        "vel": {
            "x": int(m.group(3)),
            "y": int(m.group(4)),
        }
    }
    bots.append(bot)

W = 101
H = 103
pygame.init()
win = pygame.display.set_mode([W, H])

def display():
    win.fill(0)
    for bot in bots:
        win.set_at((bot["pos"]["x"], bot["pos"]["y"]), (255, 255, 255))
    
    pygame.display.flip()

def move(f):
    for bot in bots:
        bot["pos"]["x"] = (bot["pos"]["x"] + bot["vel"]["x"] * f) % W
        bot["pos"]["y"] = (bot["pos"]["y"] + bot["vel"]["y"] * f) % H

clock = pygame.time.Clock()
running = True
step = 0
update = True
auto = True

while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
        elif event.type == pygame.KEYDOWN:
            if event.key == pygame.K_ESCAPE:
                running = False
            elif event.key == pygame.K_RIGHT:
                step += 1
                move(1)
                update = True
            elif event.key == pygame.K_LEFT:
                step -= 1
                move(-1)
                update = True
            elif event.key == pygame.K_SPACE:
                auto = not auto
    
    if auto:
        move(1)
        step += 1
        update = True
    
    if update:
        print(step)
        pygame.display.set_caption(f"Day 14 - step {step} - {clock.get_fps():.2f}fps")
        display()
        update = False
    
    clock.tick(20)
