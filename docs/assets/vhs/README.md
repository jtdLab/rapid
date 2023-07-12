To regenerate GIFs run:

#### 1. Generate Terminal GIFs using [vhs](https://github.com/charmbracelet/vhs)

```sh
sh make_all.sh
```

#### 2. Delete unneeded frames with Photoshop

#### 3. Make corners transparent with Photoshop

a) Insert Rounded Rectangle Layer with border radius `24px` and color `#18181B` below all frames
b) Select all other layers and add the clip mask
c) export
