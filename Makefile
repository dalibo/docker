all:
	$(MAKE) -C powa
images: all
	$(MAKE) images -C powa
