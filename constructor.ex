defmodule Sensor do
	defstruct id: nil, cx_id: nil, name: nil, vl: nil, fanout_ids: nil
end

defmodule Actuator do
	defstruct id: nil, cx_id: nil, name: nil, vl: nil, fanid_ids: nil
end

defmodule Neuron do
	defstruct id: nil, cx_id: nil, af: nil, input_idps: nil, output_ids: nil
end

defmodule Cortex do
	defstruct id: nil, sensor_ids: nil, actuator_ids: nil, nids: nil 
end

defmodule ID do
	def generate_ids(0, acc), do: acc  

	def generate_ids(index, acc) do 
		id = generate_id()
		generate_ids(index - 1, [id | acc])	
	end

	def generate_id() do 
		{mega_seconds, seconds, micro_seconds} = :erlang.now()
		1/(mega_seconds*100000 + seconds + micro_seconds/1000000)
	end
end

defmodule Constructor do
	require Sensor 
	require Actuator 
	require Neuron
	require Cortex 
	require ID

	def construct_genotype(sensor_name, actuator_name, hidden_layer_densities) do
		construct_genotype(ffnn, sensor_name, actuator_name, hidden_layer_densities)
	end

	def construct_genotype(fileName, sensor_name, actuator_name, hidden_layer_densities) do
		s = create_sensor(sensor_name)
		a = create_actuator(actuator_name)
		output_VL = a.vl
		layer_densities = hidden_layer_densities ++ [output_VL]
		cxID = {:cortex, generate_id())}

		neurons = create_neuro_layers(cxID, s, a, layer_densities)
		[input_layer|_] = neurons
		[output_layer|_] = :lists.reverse(neurons)
		fl_nids = [n.id]
	end

	def create_sensor(sensor_name) do 
		case sensor_name do
			:rng ->
				# Create a new rng sensor
				%Sensor{id: {:sensor, ID.generate_id()}, name: :rng, vl: 2}
			_ ->
				exit("System does not support a sensor by the name:~p", [sensor_name])
		end
	end

	def create_actuator(actuator_name) do 
		case actuator_name do
			:pts ->
				# Create a new rng sensor
				%Actuator{id: {:actuator, generate_id()}, name: :pts, vl: 1}
			_ ->
				exit("System does not support a actuator by the name:~p", [sensor_name])
		end
	end	

	def create_neuro_layers(cx_id, sensor, actuator, layer_densities) ->
		input_idps = [sensor.id, sensor.vl]
		tot_layers = length(layer_densities)
		[fl_neurons|next_lds] = layer_densities
		for x <- ID.generate_ids(fl_neurons, []), do: [{:neuron, {1, id}}]
		n_ids = [{:neuron, {1,id}} ||]
	end

	@doc """
	Generates the struct encoded genotypical representation of the cortex
	The Cortex elements needs to know the ids of every Neuron, Sensor
	and Actuator in the NN
	"""
	def create_cortex(cx_id, s_ids, a_ids, n_ids) do
		%Cortex{id: cx_id, sensor_ids: s_ids, actuator_ids: a_ids, nids: n_ids}
	end
	











end