OUTPUT_NAME = exampleplugin.so
OUTPUT_DIR = build
BFLAGS = -fPIC -shared
INPUT_FILES = ExamplePlugin/dllmain.d

all: compile clean

compile:
	@echo 'Building example plugin...'
	@dmd SDK/*.d $(INPUT_FILES) -of$(OUTPUT_DIR)/$(OUTPUT_NAME) $(BFLAGS)
	@echo 'Example plugin built'

clean:
	@rm $(OUTPUT_DIR)/*.o
	@echo 'Object files removed'
