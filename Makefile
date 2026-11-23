# make deploy        build ./app from the platform runtime + agent/, deploy the bundle, start the app
# make smoke         check /healthz and /info of the deployed app (add Q="question" for one real call)
PLATFORM ?= ../eqds-agents
TARGET ?= demo
PY ?= python3
Q ?=

.PHONY: build deploy smoke traces

build:
	$(PY) scripts/build.py --platform $(PLATFORM) --target $(TARGET)

deploy: build
	databricks bundle deploy -t $(TARGET)
	$(PY) scripts/bind_traces.py --platform $(PLATFORM) --target $(TARGET)
	databricks bundle run -t $(TARGET) research

traces:
	$(PY) scripts/bind_traces.py --platform $(PLATFORM) --target $(TARGET)

smoke:
	$(PY) scripts/smoke.py --target $(TARGET) $(if $(Q),--invoke "$(Q)")
