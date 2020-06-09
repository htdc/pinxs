v 2.1.0
[DEPRECATIONS] - Passing `%PINXS.Config{}` is being deprecated in favour of `PINXS.Client`.  HTTPoison and Poison will be removed in V3.x

V 3.0.0
[BREAKING] - HTTPoison has been removed and so passing `%PINXS.Config{}` will no longer work.  Use `PINXS.Client` to configure each request.