PYTHONPATH=$PYTHONPATH:./src

exp_files =	output/de_morph.txt\
	 output/de_noun_morph.txt\
	 output/de_verb_morph.txt\
	 output/es_morph.txt\
	 output/fi_morph.txt\
	 output/fi_noun_morph.txt\
	 output/fi_verb_morph.txt

exp: output $(exp_files)

output/de_morph.txt:
	python src/mexp.py de > $@

output/de_noun_morph.txt:
	python src/mexp.py de_noun > $@
output/de_verb_morph.txt:
	python src/mexp.py de_verb > $@
output/es_morph.txt:
	python src/mexp.py es > $@
output/fi_morph.txt:
	python src/mexp.py fi > $@
output/fi_noun_morph.txt:
	python src/mexp.py fi_noun > $@
output/fi_verb_morph.txt:
	python src/mexp.py fi_verb > $@

slot_files = output/german_nouns_slots.txt \
output/german_verbs_slots.txt \
output/finnish_nounadj_slots.txt \
output/finnish_verbs_slots.txt \
output/spanish_verbs_slots.txt

output:
	mkdir -pv $@

slots: output $(slot_files)

$(slot_files): output/%_slots.txt: paradigms/%.p
	echo "python src/paradigm.py -s $< > $@"

.PRECIOUS: morph/%.foma morph/%.foma.bin

morph: $(patsubst paradigms/%.p,morph/%.foma.bin,$(wildcard paradigms/*.p))

morph/%.foma.bin: morph/%.foma
	cd morph; foma -f $(notdir $<)

morph/%.foma: paradigms/%.p
	mkdir -p morph ; python src/morphanalyzer.py -o -c -u -s -n $(notdir $@.bin) $< > $@
holes:
	cd src; python hole.py
htest:
	python src/pextract.py < data/de_noun_h_train_dev.txt > paradigms/de_noun_h_train_dev.p
	python src/paradigm.py -p paradigms/de_noun_h_train_dev.p
cparadigm:
	python src/cparadigm.py -c paradigms/shared1_de_noun_train.p
cparadigmi:
	python src/cparadigm.py -i paradigms/shared1_de_noun_train.p

shared: $(shared1_train_txt_files)
data/shared1_ar_verb_train.txt: data/sigmorphon2016/data/arabic-task1-train 
	python src/convert_shared_data.py $< V   > $@ 
data/shared1_ar_noun_train.txt: data/sigmorphon2016/data/arabic-task1-train 
	python src/convert_shared_data.py $< N   > $@ 
data/shared1_ar_adj_train.txt: data/sigmorphon2016/data/arabic-task1-train 
	python src/convert_shared_data.py $< ADJ > $@ 

data/shared1_ka_verb_train.txt: data/sigmorphon2016/data/georgian-task1-train 
	python src/convert_shared_data.py $< V   > $@ 
data/shared1_ka_noun_train.txt: data/sigmorphon2016/data/georgian-task1-train 
	python src/convert_shared_data.py $< N   > $@ 
data/shared1_ka_adj_train.txt: data/sigmorphon2016/data/georgian-task1-train 
	python src/convert_shared_data.py $< ADJ > $@ 

data/shared1_nv_verb_train.txt: data/sigmorphon2016/data/navajo-task1-train 
	python src/convert_shared_data.py $< V   > $@ 
data/shared1_nv_noun_train.txt: data/sigmorphon2016/data/navajo-task1-train 
	python src/convert_shared_data.py $< N   > $@ 

data/shared1_es_verb_train.txt: data/sigmorphon2016/data/spanish-task1-train 
	python src/convert_shared_data.py $< V   > $@ 
data/shared1_es_noun_train.txt: data/sigmorphon2016/data/spanish-task1-train 
	python src/convert_shared_data.py $< N   > $@ 
data/shared1_es_adj_train.txt: data/sigmorphon2016/data/spanish-task1-train 
	python src/convert_shared_data.py $< ADJ > $@ 

data/shared1_fi_verb_train.txt: data/sigmorphon2016/data/finnish-task1-train 
	python src/convert_shared_data.py $< V   > $@ 
data/shared1_fi_noun_train.txt: data/sigmorphon2016/data/finnish-task1-train 
	python src/convert_shared_data.py $< N   > $@ 
data/shared1_fi_adj_train.txt: data/sigmorphon2016/data/finnish-task1-train 
	python src/convert_shared_data.py $< ADJ > $@ 

data/shared1_de_verb_train.txt: data/sigmorphon2016/data/german-task1-train 
	python src/convert_shared_data.py $< V   > $@ 
data/shared1_de_noun_train.txt: data/sigmorphon2016/data/german-task1-train 
	python src/convert_shared_data.py $< N   > $@ 
data/shared1_de_adj_train.txt: data/sigmorphon2016/data/german-task1-train 
	python src/convert_shared_data.py $< ADJ > $@ 

data/shared1_ru_verb_train.txt: data/sigmorphon2016/data/russian-task1-train 
	python src/convert_shared_data.py $< V   > $@ 
data/shared1_ru_noun_train.txt: data/sigmorphon2016/data/russian-task1-train 
	python src/convert_shared_data.py $< N   > $@ 
data/shared1_ru_adj_train.txt: data/sigmorphon2016/data/russian-task1-train 
	python src/convert_shared_data.py $< ADJ > $@ 

data/shared1_tr_verb_train.txt: data/sigmorphon2016/data/turkish-task1-train 
	python src/convert_shared_data.py $< V   > $@ 
data/shared1_tr_noun_train.txt: data/sigmorphon2016/data/turkish-task1-train 
	python src/convert_shared_data.py $< N   > $@ 

data/shared1_ar_verb_train.txt: data/sigmorphon2016/data/arabic-task1-train 
	python src/convert_shared_data.py $< V   > $@ 
data/shared1_ar_noun_train.txt: data/sigmorphon2016/data/arabic-task1-train 
	python src/convert_shared_data.py $< N   > $@ 
data/shared1_ar_adj_train.txt: data/sigmorphon2016/data/arabic-task1-train 
	python src/convert_shared_data.py $< ADJ > $@ 

data/shared1_ka_verb_train.txt: data/sigmorphon2016/data/georgian-task1-train 
	python src/convert_shared_data.py $< V   > $@ 
data/shared1_ka_noun_train.txt: data/sigmorphon2016/data/georgian-task1-train 
	python src/convert_shared_data.py $< N   > $@ 
data/shared1_ka_adj_train.txt: data/sigmorphon2016/data/georgian-task1-train 
	python src/convert_shared_data.py $< ADJ > $@ 

data/shared1_nv_verb_train.txt: data/sigmorphon2016/data/navajo-task1-train 
	python src/convert_shared_data.py $< V   > $@ 
data/shared1_nv_noun_train.txt: data/sigmorphon2016/data/navajo-task1-train 
	python src/convert_shared_data.py $< N   > $@ 

data/shared1_es_verb_train.txt: data/sigmorphon2016/data/spanish-task1-train 
	python src/convert_shared_data.py $< V   > $@ 
data/shared1_es_noun_train.txt: data/sigmorphon2016/data/spanish-task1-train 
	python src/convert_shared_data.py $< N   > $@ 
data/shared1_es_adj_train.txt: data/sigmorphon2016/data/spanish-task1-train 
	python src/convert_shared_data.py $< ADJ > $@ 

data/shared1_fi_verb_train.txt: data/sigmorphon2016/data/finnish-task1-train 
	python src/convert_shared_data.py $< V   > $@ 
data/shared1_fi_noun_train.txt: data/sigmorphon2016/data/finnish-task1-train 
	python src/convert_shared_data.py $< N   > $@ 
data/shared1_fi_adj_train.txt: data/sigmorphon2016/data/finnish-task1-train 
	python src/convert_shared_data.py $< ADJ > $@ 

data/shared1_de_verb_train.txt: data/sigmorphon2016/data/german-task1-train 
	python src/convert_shared_data.py $< V   > $@ 
data/shared1_de_noun_train.txt: data/sigmorphon2016/data/german-task1-train 
	python src/convert_shared_data.py $< N   > $@ 
data/shared1_de_adj_train.txt: data/sigmorphon2016/data/german-task1-train 
	python src/convert_shared_data.py $< ADJ > $@ 

data/shared1_ru_verb_train.txt: data/sigmorphon2016/data/russian-task1-train 
	python src/convert_shared_data.py $< V   > $@ 
data/shared1_ru_noun_train.txt: data/sigmorphon2016/data/russian-task1-train 
	python src/convert_shared_data.py $< N   > $@ 
data/shared1_ru_adj_train.txt: data/sigmorphon2016/data/russian-task1-train 
	python src/convert_shared_data.py $< ADJ > $@ 

data/shared1_tr_verb_train.txt: data/sigmorphon2016/data/turkish-task1-train 
	python src/convert_shared_data.py $< V   > $@ 
data/shared1_tr_noun_train.txt: data/sigmorphon2016/data/turkish-task1-train 
	python src/convert_shared_data.py $< N   > $@ 

# new
shared1_train_txt_files = data/shared1_ar_verb_train.txt \
	 data/shared1_ar_noun_train.txt \
	 data/shared1_ar_adj_train.txt \
	 data/shared1_ka_verb_train.txt \
	 data/shared1_ka_noun_train.txt \
	 data/shared1_ka_adj_train.txt \
	 data/shared1_nv_verb_train.txt \
	 data/shared1_nv_noun_train.txt \
	 data/shared1_es_verb_train.txt \
	 data/shared1_es_noun_train.txt \
	 data/shared1_es_adj_train.txt \
	 data/shared1_fi_verb_train.txt \
	 data/shared1_fi_noun_train.txt \
	 data/shared1_fi_adj_train.txt \
	 data/shared1_de_verb_train.txt \
	 data/shared1_de_noun_train.txt \
	 data/shared1_de_adj_train.txt \
	 data/shared1_ru_verb_train.txt \
	 data/shared1_ru_noun_train.txt \
	 data/shared1_ru_adj_train.txt \
	 data/shared1_tr_verb_train.txt \
	 data/shared1_tr_noun_train.txt 


data/shared1_tr_noun_train.txt: data/sigmorphon2016/data/turkish-task1-train N
$(filter %noun_train.txt,$(shared_train_txt_files)):
	python src/convert_shared_data.py data/sigmorphon2016/data/turkish-task1-train N   > data/shared1_tr_noun_train.txt

pshared: $(shared1_train_p_files)

$(shared1_train_p_files): paradigms/%.p: data/%.txt
	echo "python src/pextract.py < $< > $@"

shared1_train_cp_files =  paradigms/shared1_ar_verb_train.cp  \
	 paradigms/shared1_ar_noun_train.cp  \
	 paradigms/shared1_ar_adj_train.cp  \
	 paradigms/shared1_ka_verb_train.cp  \
	 paradigms/shared1_ka_noun_train.cp  \
	 paradigms/shared1_ka_adj_train.cp  \
	 paradigms/shared1_nv_verb_train.cp  \
	 paradigms/shared1_nv_noun_train.cp  \
	 paradigms/shared1_es_verb_train.cp  \
	 paradigms/shared1_es_noun_train.cp  \
	 paradigms/shared1_es_adj_train.cp  \
	 paradigms/shared1_fi_verb_train.cp  \
	 paradigms/shared1_fi_noun_train.cp  \
	 paradigms/shared1_fi_adj_train.cp  \
	 paradigms/shared1_de_verb_train.cp  \
	 paradigms/shared1_de_noun_train.cp  \
	 paradigms/shared1_de_adj_train.cp  \
	 paradigms/shared1_ru_verb_train.cp \
	 paradigms/shared1_ru_noun_train.cp \
	 paradigms/shared1_ru_adj_train.cp \
	 paradigms/shared1_tr_verb_train.cp \
	 paradigms/shared1_tr_noun_train.cp 

shared1_train_p_files =  paradigms/shared1_ar_verb_train.p  \
	 paradigms/shared1_ar_noun_train.p  \
	 paradigms/shared1_ar_adj_train.p  \
	 paradigms/shared1_ka_verb_train.p  \
	 paradigms/shared1_ka_noun_train.p  \
	 paradigms/shared1_ka_adj_train.p  \
	 paradigms/shared1_nv_verb_train.p  \
	 paradigms/shared1_nv_noun_train.p  \
	 paradigms/shared1_es_verb_train.p  \
	 paradigms/shared1_es_noun_train.p  \
	 paradigms/shared1_es_adj_train.p  \
	 paradigms/shared1_fi_verb_train.p  \
	 paradigms/shared1_fi_noun_train.p  \
	 paradigms/shared1_fi_adj_train.p  \
	 paradigms/shared1_de_verb_train.p  \
	 paradigms/shared1_de_noun_train.p  \
	 paradigms/shared1_de_adj_train.p  \
	 paradigms/shared1_ru_verb_train.p \
	 paradigms/shared1_ru_noun_train.p \
	 paradigms/shared1_ru_adj_train.p \
	 paradigms/shared1_tr_verb_train.p \
	 paradigms/shared1_tr_noun_train.p 
	
cpshared: $(shared1_train_cp_files)

$(shared1_train_cp_files): %.cp: %.p
	echo "python src/cparadigm.py -c $< > $@"

clean:
	rm -f morph/*.foma morph/*.bin

#dev:
#	mkdir -p output
#	cd src;python cexp.py ../paradigms/es_verb_train.p ../data/es_verb_dev.txt > ../output/es_verb.txt
#	cd src;python cexp.py ../paradigms/de_verb_train.p ../data/de_verb_dev.txt > ../output/de_verb.txt
#	cd src;python cexp.py ../paradigms/fi_verb_train.p ../data/fi_verb_dev.txt > ../output/fi_verb.txt
#	cd src;python cexp.py ../paradigms/de_noun_train.p ../data/de_noun_dev.txt > ../output/de_noun.txt
#	cd src;python cexp.py ../paradigms/fi_nounadj_train.p ../data/fi_nounadj_dev.txt > ../output/fi_nounadj.txt
#	tail -n 3 output/*
#test:
#	mkdir -p output
#	cd src;python cexp.py ../paradigms/es_verb_train_dev.p ../data/es_verb_test.txt > ../output/es_verb.txt
#	cd src;python cexp.py ../paradigms/de_verb_train_dev.p ../data/de_verb_test.txt > ../output/de_verb.txt
#	cd src;python cexp.py ../paradigms/fi_verb_train_dev.p ../data/fi_verb_test.txt > ../output/fi_verb.txt
#	cd src;python cexp.py ../paradigms/de_noun_train_dev.p ../data/de_noun_test.txt > ../output/de_noun.txt
#	cd src;python cexp.py ../paradigms/fi_nounadj_train_dev.p ../data/fi_nounadj_test.txt > ../output/fi_nounadj.txt
#	tail -n 3 output/*
