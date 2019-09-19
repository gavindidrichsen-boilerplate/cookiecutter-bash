main(){
	local __files=(
		colorme.sh
		include.sh
		markups.sh
	)

	for file in ${__files[@]}; do
		source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/lib/${file}
	done
}

main