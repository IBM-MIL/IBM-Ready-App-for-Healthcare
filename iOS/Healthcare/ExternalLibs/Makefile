all: build


build:
	if [ -d "Q4M.framework" ] ; \
	   then \
	   echo "Q4M Framework already exists"; \
	 else echo "not exists"; \
	   unzip q4m.zip; \
	fi;

analyze: build

clean:
	rm -rf Q4M.framework
