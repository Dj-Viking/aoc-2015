const DIM = 10;
const DIMENSIONS_ = {
    HEIGHT: DIM,
    WIDTH: DIM,
} as const;
/**
 * @example
 * ```jsx
 * <Grid>
 * [//many columns to append to the grid
 *      column 1 DOM NODE WITH CHILDREN
 *      <div class="col-0">
 *          <div class="led-0-0">, appendchild()
 *          <div class="led-0-1">,
 *          <div class="led-0-2">,
 *          ...
 *      </div>
 *      <div class="col-1">
 *          <div class="led-1-0">, appendchild()
 *          <div class="led-1-1">,
 *          ....
 *      </div >
 *
 * ]
 * </Grid>
 * ```
 */
type GridColumn = HTMLDivElement;
class Main {
    public constructor(
        private gridContainer: HTMLDivElement = null as any,
        private span: HTMLParagraphElement = null as any,
        private timer: HTMLParagraphElement = null as any,
        private cols: GridColumn[] = [],
        private readonly DIMENSIONS: typeof DIMENSIONS_ = {
            HEIGHT: DIM,
            WIDTH: DIM,
        }
    ) {
        this.span = document.createElement("p");
        this.gridContainer = document.createElement("div");
        this.timer = document.createElement("p");
        this.span.innerText = "animating";
        this.timer.innerText = "time: ";
    }

    private arrangeGridCells(): void {
        let cols = [];
        let _col = null;
        for (let row = 0; row < this.DIMENSIONS.HEIGHT; row++) {
            _col = document.createElement("div");
            _col.classList.add("grid-column");
            for (let col = 0; col < this.DIMENSIONS.WIDTH; col++) {
                const led = document.createElement("div");
                led.classList.add(`led-${col}-${row}`);
                _col.appendChild(led);
            }
            cols.push(_col);
        }
        this.cols = cols;
    }

    private createLedStyle(): string {
        let styleContent = "";
        for (let row = 0; row < this.DIMENSIONS.HEIGHT; row++) {
            for (let col = 0; col < this.DIMENSIONS.WIDTH; col++) {
                styleContent += `
                
                    @keyframes cell-opacity-${col}-${row} {
                        0% {
                            background-color: black;
                        }

                        99.999% {
                            background-color: red;
                        }
                    }

                   .led-${col}-${row} {
                        animation: cell-opacity-${col}-${row};
                        animation-duration: ${2 * row || 1}s;
                        animation-iteration-count: infinite;
                        animation-direction: alternate;
                        height: 10px;
                        width: 10px;
                        padding: 5px;
                        margin: 10px;
                    }
                `;
            }
        }

        return styleContent;
    }

    private setup() {
        const body = document.querySelector("body")!;
        const html = document.querySelector("html")!;
        const head = document.querySelector("head");
        const style = document.createElement("style");
        const heading = document.createElement("h1");

        body.style.height = "1000px";
        body.style.width = "1000px";
        html.style.height = "1000px";
        html.style.width = "1000px";
        heading.innerHTML = "<span>HELLO WORLD</span";
        style.innerHTML = this.createLedStyle();
        style.innerHTML += `

            .grid-container {
                display: flex;
                flex-direction: column;
            }

            .grid-column {
                display: flex;
                flex-direction: row;
            }
        `;
        head.appendChild(style);

        this.gridContainer.id = "gridContainer";

        this.gridContainer.classList.add("grid-container");
        this.arrangeGridCells();
        this.gridContainer.append(...this.cols);

        const els = [heading, this.span, this.timer, this.gridContainer];

        body.prepend(...els);
    }

    public main() {
        this.setup();
        console.log("main");
    }
}

new Main().main();
