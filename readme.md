This is my nvim config for mason 2.0 with java-nvim, it is still pretty hacky. Don't know why but the jdtls server sometimes doesn't want to work. I think it is mason</br>
doing things that java-nvim doesn't like. If jdtls crashes with errors the thing that helped me was cleaning the jdtls workspace so:

```console
rm -rf ~/.cache/jdtls/workspace
```
