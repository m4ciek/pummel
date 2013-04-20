# avl.sh : AVL tree implementation in bash
# 8apr13 maciek
#
# motivation: I require an efficient way to store data for allowing rich
# definition of variables on top of the existing weakly-typed variable system
# provided by bash

indent() {
	for(( i="${1}"; (( i-- )); ))
	do
		echo -n "${2}"
	done
	echo -n '> '
}

echoi() {
	indent "$((1+${1}))" $'\t'
	echo "${2}"
}

avladd() {
	echoi "${1}" "ok: adding \"""${3}""\" to \"""${4}""\""
	let "${2}"=""${3}""
	INDIR="${4}"'[0]'
	if [[ -z "${!INDIR}" ]]; then
		echoi "${1}" 'this node is null! setting...'
		eval "${4}"'[0]'=\'"${3}"\'
	else
		echoi "${1}" 'node contains a value'
		INDIR="${4}"'[1]'
		INDIR2="${4}"'[2]'
		if [[ -z "${!INDIR}" ]] && [[ -z "${!INDIR2}" ]]
		then
			echoi "${1}" 'I am terminal. New node required.'
		fi
		INDIR="${4}"'[0]'
		echoi "${1}" 'existing node has key "'"${!INDIR}"'"'
		if [[ "${!INDIR}" > "${3}" ]]
		then
			echoi "${1}" \""${!INDIR}"'" > "'"${3}"'", so I am going left'
			INDIR="${4}"'[1]'
			if [[ -z "${!INDIR}" ]]
			then
				echoi "${1}" 'left direction (ref: "'"${INDIR}"'") is terminal'
				INDIR="${4}"'[3]'
				NEWNODE=${4/%_*/}'_'"$((2#${!INDIR}0))"
				echoi "${1}" 'name will be: "'"${NEWNODE}"'"'
				echoi "${1}" 'path goes from "'"${!INDIR}"'" to "'"${!INDIR}"'0"'
				declare "${NEWNODE}"='('"${3}"' "" "" '"${!INDIR}"'0)'
				declare -p|grep AVL
			fi
		else
			echoi "${1}" \""${!INDIR}"'" <= "'"${3}"'", so I am going right'
			INDIR="${4}"'[2]'
			if [[ -z "${!INDIR}" ]]
			then
				echoi "${1}" 'right direction (ref: "'"${INDIR}"'") is terminal'
				INDIR="${4}"'[3]'
				NEWNODE=${4/%_*/}'_'"$((2#${!INDIR}1))"
				echoi "${1}" 'name will be: "'"${NEWNODE}"'"'
				echoi "${1}" 'path goes from "'"${!INDIR}"'" to "'"${!INDIR}"'1"'
				eval ""${NEWNODE}"=(\""${3}"\" \"\" \"\" "${!INDIR}"1)"
				echoi "${1}" 'yeh --> '"$(declare -p|grep AVL_)"
				echoi "${1}" 'newnode? "'"${NEWNODE}"'", iow?'
				INDIR="${NEWNODE}"'[0]'
				echoi "${1}" "${!INDIR}"
			fi
		fi
	fi
	INDIR2="${4}"'[*]'
	echoi "${1}" 'and now: "'"${!INDIR}"\"
	eval 'INDIR3=${#'"${INDIR2}"'}'
	echoi "${1}" 'count is '"${INDIR3}"' - is that right?'
}

AVLHEAD=('' '' '' 1)
unset RETVAR
echo 'ok, before: "'"${AVLHEAD[0]}"\"
for f in 'some thingy' 'ulterior motivation and so forth' 'aardvarks on a rampage'
do
	avladd 0 "RETVAR" "${f}" "AVLHEAD"
	echo 'and, after: "'"${AVLHEAD[0]}"\"
	echo 'RETVAR == '"${RETVAR}"
done
declare -p|grep AVL
