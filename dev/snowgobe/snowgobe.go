package main

import (
	"code.google.com/p/goncurses"
	"fmt"
	"os"
	"os/signal"
	"syscall"
	"time"
	"math/rand"
)

const sleepTime uint32 = 10
const maxFlakes int = 100

type flake struct { 
	x,y,vertSpeed, horzSpeed float32
	char string
}

func doExit(win *goncurses.Window) {
	win.Erase()
	win.Refresh()
	goncurses.End()
	os.Exit(0)
}


func setupSignals(win *goncurses.Window) {
	sigc := make(chan os.Signal, 1)
	signal.Notify(sigc, os.Interrupt, syscall.SIGINT, syscall.SIGTERM, syscall.SIGQUIT)
		go func() {
        sig := <-sigc
        switch sig {
        	case os.Interrupt, syscall.SIGINT, syscall.SIGTERM, syscall.SIGQUIT:
				doExit(win)
			}
		}()
}


func newRandomFlake(win *goncurses.Window) (flake) {
	_, maxWidth := win.MaxYX()
	x := rand.Float32() * float32(maxWidth)
	y := float32(0.0)
	vertSpeed := 0.3 + (rand.Float32() / 4)
	horzSpeed := (0.5 - rand.Float32()) / 2
	c := "."
	if rand.Float32() > 0.65 {
		c = "*"
		vertSpeed *= 1.5
	}
	return flake{x:x,y:y,horzSpeed:horzSpeed,vertSpeed:vertSpeed,char:c}
}

func move(win *goncurses.Window, flakes[] flake) {
	maxHeight,_ := win.MaxYX()
	for i, _ := range flakes {
		flakes[i].y += flakes[i].vertSpeed
		flakes[i].x += flakes[i].horzSpeed
		if(flakes[i].y > float32(maxHeight)) {
			flakes[i] = newRandomFlake(win)
			flakes[i].y = 0
		}
	}
	return 
}

func draw(win *goncurses.Window, flakes[] flake) {
	win.Erase()
	for _, flake := range flakes {
		win.MovePrintf(int(flake.y), int(flake.x), flake.char)
	}
    win.Refresh()
	return
}


func main() {
	win, err := goncurses.Init()
	if err != nil {
		fmt.Println("init:", err)
		os.Exit(1)
	}
	goncurses.Cursor(0)
	win.Timeout(0)
	setupSignals(win)

	flakes := make([]flake, maxFlakes)
	for i := 0; i < maxFlakes;i++ {
		flakes[i] = newRandomFlake(win)
	}

	for {
		if win.GetChar() != 0 {
			doExit(win);
		}
		time.Sleep(15 * time.Millisecond)
		move(win, flakes)
		draw(win, flakes)
	}
}
