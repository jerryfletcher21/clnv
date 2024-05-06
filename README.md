# clnv

Some [core lightning](https://github.com/ElementsProject/lightning)
scripts.

Most scripts are for visualizing the output of cln (hence the name
clnv[isualizer]), converting the json output into tables easier to read.

| Action | Description |
| --- | --- |
| `list-channels` | visualizer for listchannels |
| `list-closed-channels` | visualizer for listclosedchannels |
| `list-forwards` | visualizer for listforwards |
| `list-funds` | visualizer for listmempoolfunds (plugin) |
| `list-htlcs` | visualizer for listhtlcs |
| `list-invoices` | visualizer for listinvoices |
| `list-pays` | visualizer for listpays |
| `list-peers` | no longer useful after listpeerchannels |
| `list-pending-htlcs` | visualizer for pending htlcs (taken from listpeerchannels) |
| `pay-channel` | pay through a channel |
| `pay-status` | visualizer for paystatus from a label |
| `rebalancereport-fee-percentage` | percentage stats from rebalance plugin |
| `search` | search in listpays and listinvoices |
| `set-fee` | set fees in channels using setchannel |

## Installation and usage

To use it without insallation:
```
export CLN_BIN=<lightning-cli-bin>

./clnv --help
```

To install it so that can be used from everywhere.

Will install scripts in `~/.local/share/clnv` and a simple wrapper around
clnv that sets `CLN_BIN` named `<name-of-the-script>` in `~/.local/bin`
```
CLNV_NAME=<name-of-the-script> CLN_BIN=<lightning-cli-bin> make install

<name-of-the-script> --help
```
Then `<name-of-the-script>` can be executed from everywhere (if
`~/.local/bin` is in your `PATH`)

If you have multiple core lightning in the same machine:
```
make install-data
CLNV_NAME=<name-of-the-first-script> CLN_BIN=<first-lightning-cli-bin> make install-script
CLNV_NAME=<name-of-the-second-script> CLN_BIN=<second-lightning-cli-bin> make install-script

<name-of-the-first-script> --help
<name-of-the-second-script> --help
```

Source completions/clnv.bash-completion in `~/.bashrc`

If the bash completion package is installed there are better completions

## License

clnv is released under the terms of the ISC license.
See [LICENSE](LICENSE) for more details.
