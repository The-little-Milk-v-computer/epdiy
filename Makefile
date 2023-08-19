# Rules for generating waveform and font headers from raw data.

SUPPORTRED_DISPLAYS := ED060SC4 ED097OC4 ED097TC2 ED047TC1 ED133UT2 ED060XC3 ED060SCT

# Generate 16 grascale update waveforms + epdiy special waveforms
EXPORTED_MODES ?= 1,2,5,16,17

# Generate waveforms in room temperature range
EXPORT_TEMPERATURE_RANGE ?= 15,35

# the default headers that should come with the distribution
default: \
	$(patsubst %,src/epdiy/waveforms/epdiy_%.h,$(SUPPORTRED_DISPLAYS))

clean:
	rm src/epdiy/waveforms/epdiy_*.h
	rm src/epdiy/waveforms/eink_*.h

src/epdiy/waveforms/epdiy_%.h: src/epdiy/waveforms/epdiy_%.json
	python3 scripts/waveform_hdrgen.py \
		--export-modes $(EXPORTED_MODES) \
		--temperature-range $(EXPORT_TEMPERATURE_RANGE) \
		epdiy_$* < $< > $@

src/epdiy/waveforms/eink_%.h: src/epdiy/waveforms/eink_%.json
	python3 scripts/waveform_hdrgen.py \
		--export-modes $(EXPORTED_MODES) \
		--temperature-range $(EXPORT_TEMPERATURE_RANGE) \
		eink_$* < $< > $@

src/epdiy/waveforms/epdiy_%.json:
	python3 scripts/epdiy_waveform_gen.py $* > $@

.PHONY: default
