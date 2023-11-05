class Main {
    public start: number | undefined = undefined;
    public previousTimestamp: number | undefined = 0;
    public done: boolean = false;
    public count = 0;
    public elapsed = 0;
    public constructor(
        private span: HTMLParagraphElement = null as any,
        private timer: HTMLParagraphElement = null as any,
        private canvas: HTMLCanvasElement = null as any
    ) {
        this.span = document.createElement("p");
        this.timer = document.createElement("p");
        this.span.innerText = "animating";
        this.timer.innerText = "time: ";
        this.span.style.zIndex = "1000";
        this.canvas = document.querySelector("canvas");
    }

    private setup() {
        const body = document.querySelector("body")!;
        const html = document.querySelector("html")!;

        body.prepend(this.timer);
        body.prepend(this.span);

        body.style.height = "1000px";
        body.style.width = "1000px";
        html.style.height = "1000px";
        html.style.width = "1000px";
        // this.canvas.height = 100;
        // this.canvas.width = 100;
        this.canvas.style.height = "1000px";
        this.canvas.style.width = "1000px";
        this.canvas.style.background = "grey";
    }

    public step = (timeStamp?: number): void => {
        if (this.start === undefined) {
            this.start = timeStamp;
        }
        this.elapsed = timeStamp! / 1 - this.start!;

        // DO SOMETHING DURING THE FRAMES
        if (this.previousTimestamp! !== timeStamp) {
            // Math.min() is used here to make sure the element stops at exactly 200px
            console.log("[INFO]: elapsed time", this.elapsed);
            this.timer.innerText = `[INFO]: elapsed time: ${this.elapsed}`;
            this.count = Math.min(0.1 * this.elapsed, 200);
            const ctx = this.canvas.getContext("2d")!;
            for (let row = 0; row < 1; row++) {
                for (let col = 0; col < 1; col++) {
                    ctx.fillStyle = `hsl(100, 100%, 50%)`;
                    ctx.beginPath();
                    ctx.roundRect(col, row, 10, 10, [4]);
                    ctx.closePath();
                }
            }

            // element.style.transform = `translateX(${count}px)`;
            if (this.count === 200) {
                console.log("done animating!!!");
                this.span.innerText = "done";
                this.done = true;
            }
        }

        if (this.elapsed < 2000) {
            // Stop the animation after 2 seconds
            this.previousTimestamp = timeStamp;
            if (!this.done) {
                console.log("still animating!");

                window.requestAnimationFrame(this.step);
            }
        }
    };

    public main() {
        this.setup();
        console.log("main");

        window.requestAnimationFrame(this.step);
    }
}

new Main().main();
